class BranchSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_one :coordinator, serializer: PersonSerializer
end
