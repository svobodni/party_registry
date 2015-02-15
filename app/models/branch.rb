# Třída Branch reprezentuje místní Pobočku.
class Branch < Organization

  # patří do kraje
  belongs_to :region, :foreign_key => "parent_id"

  # má svého koordinátora
  has_one :coordinator, -> { where("since < ? and till > ?", Time.now, Time.now ) }

  # má seznam i bývalých koordinátorů
  has_many :coordinators, -> { where("till < ?", Time.now) }

  # má svého náboráře
  has_one :recruiter, -> { where("since < ? and till > ?", Time.now, Time.now ) }

  # má kmenové členy a příznivce
  has_many :domestic_people, class_name: "Person", foreign_key: "domestic_branch_id"
  has_many :domestic_members, -> { where('legacy_type="member" and member_status="regular"') },class_name: "Person", foreign_key: "domestic_branch_id"
  has_many :domestic_supporters, -> { where('legacy_type="sympathizer" and supporter_status="regular"') },class_name: "Person", foreign_key: "domestic_branch_id"

  has_many :awaiting_domestic_people, -> { where('legacy_type="member" and member_status!="regular"') },class_name: "Person", foreign_key: "domestic_branch_id"
  # má hostující členy a příznivce
  has_many :guest_people, class_name: "Person", foreign_key: "guest_branch_id"

  # má kmenové a hostující členy a příznivce
  def people
  	domestic_people+guest_people
  end

end
