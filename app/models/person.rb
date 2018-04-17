# -*- encoding : utf-8 -*-
require Rails.root.join('lib', 'dotnet_sha1')
# Třída Person reprezentuje osobu (členy a příznivce)
class Person < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :encryptable, :confirmable,
      :lockable, :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable, :omniauth_providers => [:facebook, :twitter, :mojeid]

  attr_accessor :reason

  has_many :events, as: :eventable
  has_many :notes, as: :noteable
  has_one :membership_request

  has_many :identities
  has_many :profile_pictures

  # může vykonávat funkci
  has_many :roles, -> { where("since <= ? and till >= ?", Time.now, Time.now ) }
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

  scope :regular, -> { where(status: ["regular_suporter", "regular_member"]) }
  scope :regular_members, -> { where("status = ?", "regular_member") }
  scope :regular_supporters, -> { where("status = ?", "regular_supporter") }

  scope :awaiting_first_payment, -> { where("status IN (?)", ["awaiting_first_payment", "regular_supporter_awaiting_first_payment"]) }

  scope :not_renewed, -> { where("paid_till < ?", "2018-01-01") }

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

  def is_member_or_requesting?
    is_regular_member? || is_requesting_membership?
  end

  def is_supporter?
    ["registered", "regular_supporter"].member?(status)
  end

  def membership_type
    is_regular_member? ? :member : :supporter
  end

  def is_regular?
    is_regular_member? || is_regular_supporter?
  end

  def is_regular_member?
    status == "regular_member"
  end

  def is_regular_supporter?
    status == "regular_supporter"
  end

  def vs
    (is_member_or_requesting? ? "1" : "5") + id.to_s.rjust(4,"0")
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
  end

  # podpora starého formátu
  def member_status
    return status if ["registered","regular_supporter","regular_member"].member?(status)
  end

  def status_text
    if membership_request
      "žadatel o členství"
    else
      if status == "registered"
        "nezaplacený příznivec"
      elsif status == "regular_suporter"
        "příznivec"
      elsif status == "regular_member"
        "řádný člen"
      end
    end
  end

  def is_requesting_membership?
    !membership_request.nil?
  end

  def is_awaiting_presidium_decision?
    membership_request && !membership_request.approved_on
  end

  def is_awaiting_first_payment?
    membership_request && !membership_request.paid_on
  end

  def is_awaiting_membership?
    is_requesting_membership?
  end

  def is_signed_application_expected?
    (is_regular_member? || membership_request) && signed_application.blank?
  end

  def is_payment_expected?
    #(["awaiting_first_payment", "regular_supporter_awaiting_first_payment"].member?(status) && !signed_application.blank?) || (status=="registered")
    status=="registered" || is_awaiting_first_payment?
  end

  def is_renewal_payment_expected?
    is_regular? && paid_till && paid_till.to_date < "2018-01-01".to_date
  end

  def region
    guest_region || domestic_region
  end

  include AASM

  def validate_membership_conditions(event_names=["ApplicationReceived","PaymentAccepted","PersonAccepted"])
    return false unless self.membership_request
    return false if events.empty?
    e=events.collect{|event| event.name}
    # pouze udalosti od posledni zadosti o clenstvi
    e[(e.rindex("MembershipRequested")||0)..-1]
    (event_names-e).empty?
  end


  aasm :column => 'status' do
    # zaregistrovaný nezaplacený příznivce (čeká se na platbu)
    state :registered, :initial => true
    # příznivce
    state :regular_supporter
    # zájemce o členství (čeká se na schválení a přihlášku)
    # FIXME: převod na :registered
    state :awaiting_presidium_decision
    # schválený zájemce o členství (čeká se na platbu a přihlášku)
    # FIXME: převod na :registered
    state :awaiting_first_payment
    # člen
    state :regular_member
    # příznivce zájemce o členství (čeká se na schválení a přihlášku)
    # FIXME: převod na :regular_supporter
    state :regular_supporter_awaiting_presidium_decision
    # příznivce schválený zájemce o členství (čeká se na platbu a přihlášku)
    # FIXME: převod na :regular_supporter
    state :regular_supporter_awaiting_first_payment

    # Platba členského/registračního příspěvku
    event :paid do
      # Přijímaný člen zaplatil, splnil i ostatní podmínky a stává se členem
      transitions from: :regular_supporter, to: :regular_member,
        :guard => Proc.new { self.validate_membership_conditions(["ApplicationReceived", "PersonAccepted"]) },
        :after => Proc.new { Notifier.new_regular_member(self) }

      # Přijímaný člen zaplatil a stává se příznivcem
      transitions from: :registered, to: :regular_supporter,
        :guard => Proc.new { self.membership_request },
        :after => Proc.new { MemberNotifications.supporter_paid(self).deliver }

      # Příznivec zaplatil
      transitions from: :registered, to: :regular_supporter,
        :after => Proc.new { Notifier.new_regular_supporter(self) }

      # Příznivec zaplatil na dalsi rok
      transitions from: :regular_supporter, to: :regular_supporter,
        :guard => Proc.new { is_renewal_payment_expected? },
        :after => Proc.new { SupporterNotifications.renewed(self).deliver }

      # Člen zaplatil na dalsi rok
      transitions from: :regular_member, to: :regular_member,
        :guard => Proc.new { is_renewal_payment_expected? },
        :after => Proc.new { MemberNotifications.renewed(self).deliver }
    end

    # Žádost příznivce o členství
    event :membership_requested do
      transitions from: :registered, to: :registered,
        :after => Proc.new { MemberNotifications.registered(self).deliver }
      transitions from: :regular_supporter, to: :regular_supporter,
        :after => Proc.new { MemberNotifications.supporter_membership_requested(self).deliver }
    end

    event :application_received do
      # (priznivce schvaleny zajemce o clenstvi)[uhrada doplatku]->(clen)
      transitions from: :regular_supporter, to: :regular_member,
        :guard => Proc.new { self.validate_membership_conditions(["PersonAccepted", "PaymentAccepted"]) },
        :after => Proc.new { Notifier.new_regular_member(self) }
      transitions from: :regular_supporter, to: :regular_supporter
    end

    # Členství schváleno KrP
    event :presidium_accepted do
      transitions from: :regular_supporter, to: :regular_member,
        :guard => Proc.new { self.validate_membership_conditions(["ApplicationReceived", "PaymentAccepted"])},
        :after => Proc.new { Notifier.new_regular_member(self) }
      transitions from: :regular_supporter, to: :regular_supporter,
        :guard => Proc.new { !self.validate_membership_conditions(["PaymentAccepted"])},
        :after => Proc.new { MemberNotifications.supporter_payment_pending(self).deliver }
      transitions from: :regular_supporter, to: :regular_supporter
    end

    # Členství neschváleno KrP
    event :presidium_denied do
      transitions from: :regular_supporter, to: :regular_supporter,
        :guard => Proc.new { self.membership_request.try(:previous_status)=="regular_supporter"},
        :after => Proc.new { MemberNotifications.supporter_rejected(self).deliver }
      transitions from: :regular_supporter, to: :registered,
        :after => Proc.new { MemberNotifications.rejected(self).deliver }
    end

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
      transitions :from => :regular_member, :to => :regular_supporter
    end

    # Zrušení členství na základě rozhodnutí RK
    event :rk_cancel_decision do
      transitions :from => :regular, :to => :registered
    end

    event :migrate_to_new_system do
      after do
        events.create({
          command: "MigratePerson",
          name: "PersonMigrated",
          changes: previous_changes
        })
      end
      # schvaleni, maji platebni instrukce, dokonci proces
      transitions :from => :awaiting_first_payment, :to => :registered

      transitions :from => :awaiting_presidium_decision, :to => :registered,
        :guard => Proc.new { self.membership_request.try(:membership_requested_on)<Date.parse("2018-01-01")},
        :after => Proc.new { MigrationNotifications.older(self).deliver }

      transitions :from => :awaiting_presidium_decision, :to => :registered,
        :guard => Proc.new { self.membership_request.try(:membership_requested_on)>=Date.parse("2018-01-01")},
        :after => Proc.new { MigrationNotifications.newer(self).deliver }

      transitions :from => :regular_supporter_awaiting_presidium_decision, :to => :registered,
        :guard => Proc.new { self.paid_till.to_s=="2017-12-31"}

      transitions :from => :regular_supporter_awaiting_presidium_decision, :to => :regular_supporter,
        :guard => Proc.new { self.paid_till.to_s=="2018-12-31"}
    end
  end

  def files_photo_url
    "https://files.svobodni.cz/rep/is/member_photo/#{id}.png"
  end

  def photo_url
    "https://registr.svobodni.cz/people/#{id}/photo.png"
  end

  def cv_url
    cv.size ? "https://registr.svobodni.cz/people/#{id}/cv.pdf" : ""
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
    if guest_branch_id_changed? && guest_branch.coordinator
      CoordinatorNotifications.guesting_person_joined(self).deliver_now
    end
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
