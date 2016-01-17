# -*- encoding : utf-8 -*-
require Rails.root.join('lib', 'dotnet_sha1')
# Třída Person reprezentuje osobu (členy a příznivce)
class Person < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :encryptable, :confirmable,
      :lockable, :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable, :omniauth_providers => [:facebook, :twitter, :mojeid, :trezor]

  has_many :events, as: :eventable

  has_many :identities

  # může vykonávat funkci
  has_many :roles, -> { where("since < ? and till > ?", Time.now, Time.now ) }
  # vykonával funkci
  has_many :historic_roles, -> { where("till < ?", Time.now) }, source: :role, class_name: Role
  # ve voleném orgánu
  has_many :bodies, through: :roles
  # může být koordinátorem více poboček
  has_many :coordinated_branches, through: :roles, source: :branch
  # patří do kraje dle volebního práva
  belongs_to :domestic_region, class_name: "Region"
  # hostuje v kraji dle své volby
  belongs_to :guest_region, class_name: "Region"
  # patří do pobočky dle volebního práva
  belongs_to :domestic_branch, class_name: "Branch"
  # hostuje v pobočce dle své volby
  belongs_to :guest_branch, class_name: "Branch"
  # má adresy (bydliště, poštovní)
  belongs_to :domestic_ruian_address, class_name: :RuianAddress, foreign_key: :domestic_address_ruian_id
  belongs_to :postal_ruian_address, class_name: :RuianAddress, foreign_key: :postal_address_ruian_id
  # má záznamy o přihlášení do systémů
  has_many :issued_token_log_entries
  # má v systému scan přihlášky
  has_one :signed_application
  # má v systému životopis
  has_attached_file :cv, path: ":rails_root/data/cvs/:id.pdf"
  validates_attachment_content_type :cv, content_type: 'application/pdf'
  # má kontaktní údaje
  has_many :contacts, as: :contactable, dependent: :destroy

  scope :regular_members, -> { where("status = ?", "regular_member") }
  scope :regular_supporters, -> { where("status = ?", "regular_supporter") }

  scope :awaiting_first_payment, -> { where("status IN (?)", ["awaiting_first_payment", "regular_supporter_awaiting_first_payment"]) }

  scope :not_renewed, -> { where("paid_till < ?", "2016-01-01") }

  scope :without_signed_application, -> { joins(:signed_application).where("signed_applications.person_id IS NULL") }

  scope :awaiting_presidium_decision, -> { where("status IN (?)", ["awaiting_presidium_decision", "regular_supporter_awaiting_presidium_decision"]) }

  before_save :unset_domestic_ruian_address,
    if: Proc.new { |person| person.domestic_address_street_changed? }

  before_save :set_guest_region

  before_update :import_domestic_ruian_address,
    if: Proc.new { |person| person.domestic_address_ruian_id_changed? }

  after_create :set_membership_type
  before_save :notify_coordinator
  after_create :notify_member_registered
  after_create :store_creation_event

  # změny evidujeme
  has_paper_trail

  with_options if: :is_supporter_registration?, on: :create do |supporter|
    supporter.validates :password, length: { minimum: 7 }
    supporter.validates :email, presence: true
    supporter.validates :phone, presence: true
  end

  # checkbox v registraci
  attr_accessor :agree
  validates :agree, presence: true, acceptance: true, on: :create
  validates :amount, presence: true, on: :create

  def is_supporter_registration?
    legacy_type=="supporter"
  end

  with_options unless: :is_supporter_registration?, on: :create do |member|
    member.validates :password, length: { minimum: 7 }
    member.validates :email, presence: true
    member.validates :phone, presence: true
  end

  # Přihlašovací jméno je povinný údaj
  validates :username, presence: true, uniqueness: true

  # Jméno je povinný údaj, minimální délka 3
  validates_presence_of :first_name
  validates :first_name, length: { minimum: 2 }

  # Příjmení je povinný údaj, minimální délka 3
  validates_presence_of :last_name
  validates :last_name, length: { minimum: 2 }

  # Datum narození je povinný údaj
  validates_presence_of :date_of_birth

  # Adresa bydliště je povinný údaj
  validates_presence_of :domestic_address_street
  validates_presence_of :domestic_address_city
  validates_presence_of :domestic_address_zip

  # Každá osoba je přiřazena do nějakého kraje
  validates :domestic_region, presence: true

  # sestaví jméno osoby včetně titulů, vhodné pro zobrazování
  def name
  	[[name_prefix, first_name, last_name].reject(&:blank?).join(' '),name_suffix].reject(&:blank?).join(', ')
  end

  # sestaví jméno osoby, vhodné pro zobrazování
  def short_name
    [first_name, last_name].join(' ')
  end


  def domestic_address_line
    "#{domestic_address_street}, #{domestic_address_zip} #{domestic_address_city}"
  end

  def postal_address_line
    "#{postal_address_street}, #{postal_address_zip} #{postal_address_city}"
  end

  def is_member?
    ["regular_member","awaiting_presidium_decision", "awaiting_first_payment", "regular_supporter_awaiting_presidium_decision", "regular_supporter_awaiting_first_payment"].member?(status)
  end

  def is_supporter?
    ["registered", "regular_supporter", "regular_supporter_awaiting_presidium_decision", "regular_supporter_awaiting_first_payment"].member?(status)
  end

  def membership_type
    is_member? ? :member : :supporter
  end

  def is_regular?
    is_regular_member? || is_regular_supporter?
  end

  def is_regular_member?
    status == "regular_member"
  end

  def self.regular_supporter_states
    ["regular_supporter","regular_supporter_awaiting_presidium_decision","regular_supporter_awaiting_first_payment"]
  end

  def is_regular_supporter?
    Person.regular_supporter_states.member?(status)
  end

  def vs
    (is_member? ? "1" : "5") + id.to_s.rjust(4,"0")
  end

  def member_vs
    "1" + id.to_s.rjust(4,"0")
  end

  def supporter_vs
    "5" + id.to_s.rjust(4,"0")
  end

  # podpora starého formátu
  def supporter_status
    return status if ["registered", "regular_supporter"].member?(status)
    return "regular_supporter" if ["regular_supporter_awaiting_presidium_decision","regular_supporter_awaiting_first_payment"].member?(status)
  end

  # podpora starého formátu
  def member_status
    return status if ["regular_member","awaiting_presidium_decision", "awaiting_first_payment"].member?(status)
    return "awaiting_presidium_decision" if status == "regular_supporter_awaiting_presidium_decision"
    return "awaiting_first_payment" if status == "regular_supporter_awaiting_first_payment"
  end

  def status_text
    if is_member?
      if status == "regular_member"
        "řádný člen"
      else
        "žadatel o členství"
      end
    else
      if status == "regular_supporter"
        "příznivec"
      else
        "nezaplacený příznivec"
      end
    end
  end

  def is_awaiting_presidium_decision?
    ["awaiting_presidium_decision", "regular_supporter_awaiting_presidium_decision"].member?(status)
  end

  def is_awaiting_first_payment?
    ["awaiting_first_payment", "regular_supporter_awaiting_first_payment"].member?(status)
  end

  def self.awaiting_states
    ["awaiting_presidium_decision", "awaiting_first_payment", "regular_supporter_awaiting_presidium_decision", "regular_supporter_awaiting_first_payment"]
  end

  def is_awaiting_membership?
    Person.awaiting_states.member?(status)
  end

  def is_signed_application_expected?
    is_member? && signed_application.blank?
  end

  def is_payment_expected?
    #(["awaiting_first_payment", "regular_supporter_awaiting_first_payment"].member?(status) && !signed_application.blank?) || (status=="registered")
    ["registered", "awaiting_first_payment", "regular_supporter_awaiting_first_payment"].member?(status)
  end

  def is_renewal_payment_expected?
    is_regular? && paid_till && paid_till.to_date < "2016-01-01".to_date
  end

  def region
    guest_region || domestic_region
  end

  include AASM

  aasm :column => 'status' do
    # zaregistrovaný nezaplacený příznivce (čeká se na platbu)
    state :registered, :initial => true
    # příznivce
    state :regular_supporter
    # zájemce o členství (čeká se na schválení a přihlášku)
    state :awaiting_presidium_decision
    # schválený zájemce o členství (čeká se na platbu a přihlášku)
    state :awaiting_first_payment
    # člen
    state :regular_member
    # příznivce zájemce o členství (čeká se na schválení a přihlášku)
    state :regular_supporter_awaiting_presidium_decision
    # příznivce schválený zájemce o členství (čeká se na platbu a přihlášku)
    state :regular_supporter_awaiting_first_payment

    # Platba členského/registračního příspěvku
    event :paid do
      # Příznivec zaplatil
      # (nezaplaceny priznivce)[uhrada 100]->(priznivce)
      transitions from: :registered, to: :regular_supporter, :after => Proc.new { Notifier.new_regular_supporter(self) }
      # Příznivec zaplatil znovu
      transitions from: :regular_supporter, to: :regular_supporter, :after => Proc.new { SupporterNotifications.renewed(self).deliver }
      # Přijatý člen zaplatil
      # (schvaleny zajemce o clenstvi)[uhrada 1000]->(clen)
      transitions from: :awaiting_first_payment, to: :regular_member, :after => Proc.new { Notifier.new_regular_member(self) }
      # Člen zaplatil znovu
      transitions from: :regular_member, to: :regular_member, :after => Proc.new { MemberNotifications.renewed(self).deliver }
      # (priznivce schvaleny zajemce o clenstvi)[uhrada doplatku]->(clen)
      transitions from: :regular_supporter_awaiting_first_payment, to: :regular_member
    end

    # Žádost příznivce o členství
    event :membership_requested do
      # (nezaplaceny priznivce)->(zajemce o clenstvi)
      transitions :from => :registered, :to => :awaiting_presidium_decision
      # (priznivce)->(priznivce zajemce o clenstvi)
      transitions :from => :regular_supporter, :to => :regular_supporter_awaiting_presidium_decision
    end

    # Členství schváleno KrP
    event :presidium_accepted do
      # (zajemce o clenstvi)[prihlaska a usneseni]->(schvaleny zajemce o clenstvi)
      transitions :from => :awaiting_presidium_decision,
                  :to => :awaiting_first_payment,
                  :after => Proc.new { MemberNotifications.accepted(self).deliver }

      # (priznivce zajemce o clenstvi)->(priznivce schvaleny zajemce o clenstvi)
      transitions :from => :regular_supporter_awaiting_presidium_decision, :to => :regular_supporter_awaiting_first_payment
    end

    # Členství neschváleno KrP
    #event :presidium_denied do
    #  transitions :from => :awaiting_presidium_decision, :to => :cancelled
    #end

    # Roční deaktivace nezaplacených členů
    event :anual_check do
      # (clen)[neobnovil]->(nezaplaceny priznivce)
      transitions :from => :regular_member, :to => :registered
      # (priznivce)[neobnovil]->(nezaplaceny priznivce)
      transitions :from => :regular_supporter, :to => :registered
    end

    # Zrušení členství nebo žádosti o členství na žádost člena
    event :cancel_request do
      # (clen)[ukoncil clenstvi]->(nezaplaceny priznivce)
      transitions :from => :awaiting_presidium_decision, :to => :registered
      transitions :from => :awaiting_first_payment, :to => :registered
      transitions :from => :regular_member, :to => :regular_supporter
    end

    # Zrušení členství na základě rozhodnutí RK
    event :rk_cancel_decision do
      transitions :from => :regular, :to => :registered
    end
  end

  def files_photo_url
    "https://files.svobodni.cz/rep/is/member_photo/#{id}.png"
  end

  def files_cv_url
    "https://files.svobodni.cz/rep/is/member_cv/#{id}.pdf"
  end

  def photo_url
    "https://registr.svobodni.cz/people/#{id}/photo.png"
  end

  def cv_url
    "https://registr.svobodni.cz/people/#{id}/cv.pdf"
  end

  def set_domestic_ruian_address
    self.domestic_ruian_address = RuianAddress.find_or_create_by_address_line(domestic_address_line)
  end

  def unset_domestic_ruian_address
    self.domestic_ruian_address = nil
  end

  def import_domestic_ruian_address
    begin
      RuianAddress.import(domestic_address_ruian_id) unless domestic_address_ruian_id.blank?
    rescue
    end
  end

  def phone_name_region
    "#{phone}: #{name} (#{domestic_region.name})"
  end

  def name_id_region
    "#{id}: #{name} (#{domestic_region.name})"
  end

  def name_id_region_status
    "#{name_id_region} - [#{I18n.t(status, scope: :person_status)}]"
  end

  def email_name_id_region
    "#{email}: #{name_id_region}"
  end

  def set_membership_type
    membership_requested! if legacy_type=="member"
  end

  def notify_coordinator
    CoordinatorNotifications.guesting_person_joined(self).deliver_now if guest_branch_id_changed?
  end

  def notify_member_registered
    PresidiumNotifications.member_registered(self).deliver_now if awaiting_presidium_decision?
  end

  def store_creation_event
    if legacy_type=="member"
      events.create({
        command: "RequestMembership",
        name: "MembershipRequested",
        changes: previous_changes
      })
    else
      events.create({
        command: "RegisterSupporter",
        name: "SupporterRegistered",
        changes: previous_changes
      })
    end
  end

  def set_guest_region
    self.guest_region = guest_branch.region if guest_branch_id_changed?
  end

end
