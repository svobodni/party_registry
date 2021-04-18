# -*- encoding : utf-8 -*-
require Rails.root.join('lib', 'dotnet_sha1')
# Třída Person reprezentuje osobu (členy a příznivce)
class Person < ApplicationRecord
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
  has_many :historic_roles, -> { where("till < ?", Time.now) }, source: :role, class_name: 'Role'
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

  scope :regular, -> { where(status: ["regular_supporter", "regular_member"]) }
  scope :regular_members, -> { where("status = ?", "regular_member") }
  scope :regular_supporters, -> { where("status = ?", "regular_supporter") }

  scope :awaiting_first_payment, -> { joins(:membership_request).where("membership_requests.paid_on IS NULL") }

  scope :not_renewed, -> { where("paid_till < ?", "2021-01-01") }

  scope :without_signed_application, -> { joins(:signed_application).where("signed_applications.person_id IS NULL") }

  scope :awaiting_presidium_decision, -> { joins(:membership_request).where("membership_requests.approved_on IS NULL") }

  before_save :unset_domestic_ruian_address,
    if: Proc.new { |person| person.domestic_address_street_changed? }

  before_save :set_guest_region

  before_update :import_domestic_ruian_address,
    if: Proc.new { |person| person.domestic_address_ruian_id_changed? }

  after_create :set_membership_type
  before_save :notify_coordinator
  after_create :store_creation_event
  after_create :notify_member_registered
  after_create :welcome_new_supporter

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
    id
  end

  # podpora starého formátu
  def supporter_status
    return status if is_regular_supporter?
  end

  # podpora starého formátu
  def member_status
    return status if is_regular_member?
  end

  # FIXME: do helperu k mapě!
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
    is_requesting_membership? && !membership_request.approved?
  end

  def is_awaiting_first_payment?
    is_requesting_membership? && !membership_request.paid?
  end

  def is_awaiting_membership?
    is_requesting_membership?
  end

  def is_signed_application_expected?
    (is_regular_member? || is_requesting_membership?) && signed_application.blank?
  end

  def is_payment_expected?
    status=="registered" || is_awaiting_first_payment?
  end

  def is_renewal_payment_expected?
    is_regular? && paid_till && attribute_was(:paid_till).to_date < "2021-01-01".to_date
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
    e=e[(e.rindex("MembershipRequested")||0)..-1]
    (event_names-e).empty?
  end


  aasm :column => 'status' do
    # zaregistrovaný nezaplacený příznivce (čeká se na platbu)
    state :registered, :initial => true
    # příznivce
    state :regular_supporter
    # člen
    state :regular_member

    # Platba členského příspěvku
    event :member_paid do
      # Přijímaný člen zaplatil, splnil i ostatní podmínky a stává se členem
      transitions from: [:registered, :regular_supporter], to: :regular_member,
        :guard => Proc.new { self.validate_membership_conditions(["ApplicationReceived", "PersonAccepted"]) },
        :after => Proc.new { Notifier.new_regular_member(self) }

      # Přijímaný člen zaplatil a stává se příznivcem
      transitions from: :registered, to: :regular_supporter,
        :guard => Proc.new { self.is_requesting_membership? },
        :after => Proc.new {
          MemberNotifications.paid(self).deliver
          PresidiumNotifications.requesting_paid(self).deliver
        }

      # Přijímaný příznivec zaplatil
      transitions from: :regular_supporter, to: :regular_supporter,
        :guard => Proc.new { self.is_requesting_membership? && self.membership_request.previous_status=="regular_supporter"},
        :after => Proc.new {
          MemberNotifications.supporter_paid(self).deliver
          PresidiumNotifications.requesting_paid(self).deliver
        }

      # Člen zaplatil na dalsi rok
      transitions from: :regular_member, to: :regular_member,
        :guard => Proc.new { self.is_renewal_payment_expected? },
        :after => Proc.new { MemberNotifications.renewed(self).deliver }
    end

    # Platba členského/registračního příspěvku
    event :supporter_paid do
      # Příznivec zaplatil
      transitions from: :registered, to: :regular_supporter,
        :after => Proc.new { Notifier.new_regular_supporter(self) }

      # Příznivec zaplatil na dalsi rok
      transitions from: :regular_supporter, to: :regular_supporter,
        :guard => Proc.new { self.is_renewal_payment_expected? },
        :after => Proc.new { SupporterNotifications.renewed(self).deliver }
    end

    # Žádost příznivce o členství
    event :membership_requested do
      transitions from: :registered, to: :registered,
        :after => Proc.new { Notifier.new_membership_request(self) }
      transitions from: :regular_supporter, to: :regular_supporter,
        :after => Proc.new { MemberNotifications.supporter_membership_requested(self).deliver }
    end

    event :application_received do
      # (priznivce schvaleny zajemce o clenstvi)[uhrada doplatku]->(clen)
      transitions from: [:registered, :regular_supporter], to: :regular_member,
        :guard => Proc.new { self.validate_membership_conditions(["PersonAccepted", "PaymentAccepted"]) },
        :after => Proc.new { Notifier.new_regular_member(self) }
      transitions from: :registered, to: :registered
      transitions from: :regular_supporter, to: :regular_supporter
    end

    # Členství schváleno KrP
    event :presidium_accepted do
      transitions from: [:registered,:regular_supporter], to: :regular_member,
        :guard => Proc.new { self.validate_membership_conditions(["ApplicationReceived", "PaymentAccepted"])},
        :after => Proc.new { Notifier.new_regular_member(self) }
      transitions from: :regular_supporter, to: :regular_supporter,
        :guard => Proc.new { !self.validate_membership_conditions(["PaymentAccepted"])},
        :after => Proc.new { MemberNotifications.supporter_payment_pending(self).deliver }
      transitions from: :regular_supporter, to: :regular_supporter
      transitions from: :registered, to: :registered
    end

    # Členství neschváleno KrP
    event :presidium_denied do
      after do
        OfficeNotification.membership_request_rejected(self).deliver
      end
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
    PresidiumNotifications.member_registered(self).deliver_now if legacy_type=="member"
  end

  def welcome_new_supporter
    SupporterNotifications.registered(self).deliver_now unless legacy_type=="member"
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
