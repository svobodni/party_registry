class BodySerializer < ActiveModel::Serializer
  attributes :id, :name, :acronym, :organization_id
  has_many :members, serializer: PersonSerializer
  has_one :chairman, serializer: PersonSerializer
  has_many :vicechairmen, serializer: PersonSerializer
end
