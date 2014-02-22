class RegionSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_many :branches
  has_one :board, serializer: BodySerializer
end
