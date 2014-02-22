# Třída Branch reprezentuje místní Pobočku.
class Branch < Organization

  # patří do kraje
  belongs_to :region, :foreign_key => "parent_id"

  # má svého koordinátora
  has_one :coordinator

  # má seznam i bývalých koordinátorů
  has_many :coordinators

  # má kmenové členy a příznivce
  has_many :domestic_people, class_name: "Person", foreign_key: "domestic_branch_id"

  # má hostující členy a příznivce
  has_many :guest_people, class_name: "Person", foreign_key: "guest_branch_id"

  # má kmenové a hostující členy a příznivce
  def people
  	domestic_people+guest_people
  end

end
