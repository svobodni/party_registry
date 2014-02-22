# Třída Region reprezentuje Krajské sdružení
class Region < Organization
  belongs_to :country, :foreign_key => "parent_id"
  has_many :branches, :foreign_key => "parent_id"
  has_one :board, :class_name => Body, :foreign_key => "organization_id"

  # má kmenové členy a příznivce
  has_many :domestic_people, class_name: "Person", foreign_key: "domestic_region_id"

  # má hostující členy a příznivce
  has_many :guest_people, class_name: "Person", foreign_key: "guest_region_id"

  # má kmenové a hostující členy a příznivce
  def people
  	domestic_people+guest_people
  end
end
