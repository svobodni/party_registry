# Třída reprezentuje orgán strany (ReP, Rev, KrP, RK, KK, VK)
class Body < ApplicationRecord
  belongs_to :organization

  # Členové jsou v orgánech v rolích/funkcích (předseda, místopředseda, koordinátor, člen)

  # v roli jsou jen během funkčního období
  has_many :roles, -> { where("since < ? and till > ?", Time.now, Time.now	) }
  has_many :people, through: :roles

  # seznam bývalých funkcionářů
  has_many :historic_roles, -> { where("till < ?", Time.now) }, class_name: 'Role'
  has_many :historic_people, through: :historic_roles, source: :person

  # Stávající předseda orgánu (u předsednictev)
  has_one :president, -> { where("since < ? and till > ?", Time.now, Time.now  ) }, class_name: 'President'

  # Stávající místopředsedové orgánu (u předsednictev)
  has_many :vicepresidents, -> { where("since < ? and till > ?", Time.now, Time.now  ) }, class_name: 'Vicepresident'

  scope :order_for_display, -> { order(display_position: :asc) }

  # Stávající členové orgánu (u komisí)
  def members
  	people.where("type='Member'")
  end

  def presidium_emails
    emails = vicepresidents.collect{|vp| vp.person.email}
    emails << president.try(:person).try(:email)
    emails
  end
end
