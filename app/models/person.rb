class Person < ActiveRecord::Base
  has_many :roles
  has_many :bodies, through: :roles

  def name
  	[first_name, last_name].join(' ')
  end

end
