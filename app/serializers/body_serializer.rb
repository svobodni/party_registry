class BodySerializer < ActiveModel::Serializer
  attributes :id, :name, :acronym, :organization_id
  has_many :members, serializer: PublicPersonSerializer
  has_one :chairman, serializer: PublicPersonSerializer
  has_many :vicechairmen, serializer: PublicPersonSerializer
end
