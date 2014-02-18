class Region < Organization
  belongs_to :country, :foreign_key => "parent_id"
  has_many :branches, :foreign_key => "parent_id"
end
