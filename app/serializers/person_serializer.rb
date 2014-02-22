class PersonSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :member_status, :supporter_status
end
