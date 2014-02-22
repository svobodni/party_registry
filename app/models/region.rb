# Třída Region reprezentuje Krajské sdružení
class Region < Organization
  belongs_to :country, :foreign_key => "parent_id"
  has_many :branches, :foreign_key => "parent_id"
  has_one :board, :class_name => Body, :foreign_key => "organization_id"
end
