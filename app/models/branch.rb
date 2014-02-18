class Branch < Organization
  belongs_to :region, :foreign_key => "parent_id"
end
