# Třída reprezentuje orgán strany (ReP, Rev, KrP, RK, KK, VK)
class Body < ActiveRecord::Base
  belongs_to :organization

  # Členové jsou v orgánech v rolích/funkcích (předseda, místopředseda, koordinátor, člen)

  # v roli jsou jen během funkčního období
  has_many :roles, -> { where("since < ? and till > ?", Time.now, Time.now	) }
  has_many :people, through: :roles

  # seznam bývalých funkcionářů
  has_many :historic_roles, -> { where("till < ?", Time.now) }, source: :role, class_name: Role
  has_many :historic_people, through: :historic_roles, source: :person

  # Stávající předseda orgánu (u předsednictev)
  has_one :president, -> { where("since < ? and till > ?", Time.now, Time.now  ) }, class_name: President

  # Stávající místopředsedové orgánu (u předsednictev)
  has_many :vicepresidents, -> { where("since < ? and till > ?", Time.now, Time.now  ) }, class_name: Vicepresident

  # Stávající členové orgánu (u komisí)
  def members
  	people.where("type='Member'")
  end

end
