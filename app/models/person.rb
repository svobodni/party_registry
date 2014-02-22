# Třída Person reprezentuje osobu (členy a příznivce)
class Person < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # může vykonávat funkci
  has_many :roles
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

  # změny evidujeme
  has_paper_trail

  validates_presence_of :first_name
  validates :first_name, length: { minimum: 3 }

  validates_presence_of :last_name
  validates :last_name, length: { minimum: 3 }

  validates :domestic_region, presence: true

  def name
  	[first_name, last_name].join(' ')
  end

  def has_role?(role)
    role == :krp_member
  end

  include AASM

  aasm :column => 'member_status' do
    state :awaiting_application, :initial => true
    state :awaiting_board_decision
    state :awaiting_first_payment
    state :regular
    state :cancelled

    # Přijatá přihláška
    event :received_application do
      transitions :from => :awaiting_application, :to => :awaiting_board_decision
    end

    # Členství schváleno KrP
    event :board_accepted do
      transitions :from => :awaiting_board_decision, :to => :awaiting_first_payment
      # FIXME: obnoveni clenstvi
    end

    # Členství neschváleno KrP
    event :board_denied do
      transitions :from => :awaiting_board_decision, :to => :cancelled
    end

    # Zaplacení členského příspěvku
    event :payment do
      transitions :from => :awaiting_first_payment, :to => :regular
      transitions :from => :regular, :to => :regular
      transitions :from => :cancelled, :to => :awaiting_board_decision
    end

    # Roční deaktivace nezaplacených členů
    event :anual_check do
      transitions :from => :regular, :to => :cancelled
    end

    # Zrušení členství nebo žádosti o členství na žádost člena
    event :cancel_request do
      transitions :from => :awaiting_application, :to => :cancelled
      transitions :from => :awaiting_board_decision, :to => :cancelled
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

end
