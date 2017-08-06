# Třída Country reprezentuje republikovou úroveň
class Country < Organization
  has_many :regions, :foreign_key => "parent_id"

  def members_account_number
    "2100382818"
  end

  def supporters_account_number
    "7505075050"
  end

end
