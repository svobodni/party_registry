class BodySerializer < ActiveModel::Serializer
  attributes :id, :name, :acronym, :organization_id, :type
  has_many :members, serializer: RoleSerializer
  has_one :president, serializer: RoleSerializer
  has_many :vicepresidents, serializer: RoleSerializer
  has_one :organization, polymorphic: true
end
