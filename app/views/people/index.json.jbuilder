json.people @people do |person|
  json.type person.legacy_type
  json.name person.name
  json.first_name person.first_name
  json.last_name person.last_name
  json.email person.email
  json.phone person.phone
  json.domestic_region do
    json.name person.domestic_region.name
  end
  json.domestic_branch do
    json.name person.domestic_branch.try(:name)
  end
end
