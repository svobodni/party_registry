# -*- encoding : utf-8 -*-
require Rails.root.join('lib', 'dotnet_sha1')
# Třída Person reprezentuje osobu (členy a příznivce)
class Person < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :encryptable,
         :recoverable, :rememberable, :trackable #, :validatable

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
  # má kontaktní údaje
  has_many :contacts, :as => :contactable

  scope :regular_members, -> { where("member_status = ?", "regular") }

#  before_save :set_domestic_ruian_address,
#    if: Proc.new { |person| person.domestic_address_street_changed? }

  before_update :import_domestic_ruian_address,
    if: Proc.new { |person| person.domestic_address_ruian_id_changed? }

  before_save :notify_coordinator

  # změny evidujeme
  has_paper_trail

  # Jméno je povinný údaj, minimální délka 3
  validates_presence_of :first_name
#  validates :first_name, length: { minimum: 3 }

  # Příjmení je povinný údaj, minimální délka 3
  validates_presence_of :last_name
  validates :last_name, length: { minimum: 3 }

  #validates :domestic_region, presence: true

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

  def is_member?
    ["awaiting_presidium_decision", "awaiting_first_payment", "regular"].member?(member_status)
  end

  def is_supporter?
    ["registered", "regular"].member?(supporter_status)
  end

  def membership_type
    legacy_type == "member" ? :member : :supporter
  end

  def is_regular?
    member_status == "regular" || supporter_status == "regular"
  end

  def is_regular_member?
    is_member? && status == "valid"
  end

  def is_regular_supporter?
    supporter_status=="regular"
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

  def status
    if is_member?
      member_status == "regular" ? "valid" : "other"
    else
      supporter_status == "regular" ? "valid" : "other"
    end
  end

  def status_text
    if is_member?
      if member_status == "regular"
        "řádný člen"
      else
        "žadatel o členství"
      end
    else
      if supporter_status == "regular"
        "příznivec"
      else
        "nezaplacený příznivec"
      end
    end
  end

  def awaiting_membership?
    ["awaiting_presidium_decision", "awaiting_first_payment"].member?(member_status)
  end

  def signed_application_expected?
    awaiting_membership? && signed_application.blank?
  end

  def payment_expected?
    ((member_status == "awaiting_first_payment") && !signed_application.blank?) || (supporter_status=="registered")
  end

  def region
    guest_region || domestic_region
  end

  include AASM

  aasm :column => 'member_status' do
    state :awaiting_presidium_decision, :initial => true
    state :awaiting_first_payment
    state :regular
    state :cancelled

    # Členství schváleno KrP
    event :presidium_accepted do
      transitions :from => :awaiting_presidium_decision, :to => :awaiting_first_payment
      # FIXME: obnoveni clenstvi
    end

    # Členství neschváleno KrP
    event :presidium_denied do
      transitions :from => :awaiting_presidium_decision, :to => :cancelled
    end

    # Zaplacení členského příspěvku
    event :payment do
      transitions :from => :awaiting_first_payment, :to => :regular
      transitions :from => :regular, :to => :regular
      transitions :from => :cancelled, :to => :awaiting_presidium_decision
    end

    # Roční deaktivace nezaplacených členů
    event :anual_check do
      transitions :from => :regular, :to => :cancelled
    end

    # Zrušení členství nebo žádosti o členství na žádost člena
    event :cancel_request do
      transitions :from => :awaiting_presidium_decision, :to => :cancelled
      transitions :from => :awaiting_first_payment, :to => :cancelled
      transitions :from => :regular, :to => :cancelled
    end

    # Zrušení členství na základě rozhodnutí RK
    event :rk_cancel_decision do
      transitions :from => :regular, :to => :cancelled
    end

  end

  aasm :column => 'supporter_status' do
    state :registered, :initial => true
    state :regular
    state :cancelled

    # Zaplacení daru příznivce
    event :payment do
      transitions :from => :registered, :to => :regular
      transitions :from => :cancelled, :to => :regular
      transitions :from => :regular, :to => :regular
    end

    # Roční deaktivace nezaplacených členů
    event :anual_check do
      transitions :from => :regular, :to => :cancelled
    end

    # Zrušení členství na žádost člena
    event :cancel_request do
      transitions :from => :regular, :to => :cancelled
    end

  end

  def guest_region_id
    if configatron.migrated?
      super
    else
      guest_branch_id.blank? ? super : guest_branch.region.id
    end
  end

  def guest_region
    if configatron.migrated?
      super
    else
      guest_region_id.blank? ? super : Region.find_by_id(guest_region_id)
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

  def import_domestic_ruian_address
    RuianAddress.import(domestic_address_ruian_id) unless domestic_address_ruian_id.blank?
  end

  def name_id_region
    "#{id}: #{name} (#{domestic_region.name})"
  end

  def notify_coordinator
    CoordinatorNotifications.guesting_person_joined(self).deliver if guest_branch_id_changed?
  end

end
