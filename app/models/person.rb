# Třída Person reprezentuje osobu (členy a příznivce)
class Person < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :roles
  has_many :bodies, through: :roles

  has_many :coordinated_branches, through: :roles, source: :branch

  belongs_to :domestic_region, class_name: "Region"
  belongs_to :guest_region, class_name: "Region"
  belongs_to :domestic_branch, class_name: "Branch"
  belongs_to :guest_branch, class_name: "Branch"

  def name
  	[first_name, last_name].join(' ')
  end

end
