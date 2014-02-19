class Body < ActiveRecord::Base
  belongs_to :organization
  has_many :roles
  has_many :people, through: :roles
end
