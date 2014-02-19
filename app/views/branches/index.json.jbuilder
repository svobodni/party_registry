json.array!(@branches) do |branch|
  json.extract! branch, :id, :type, :name, :parent_id
  json.url branch_url(branch, format: :json)
end
