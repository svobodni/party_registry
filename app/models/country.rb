class Country < Organization
  has_many :regions, :foreign_key => "parent_id"
end
