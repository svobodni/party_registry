json.payment do
  json.region_id @person.domestic_region_id
  json.id @person.id
  json.name @person.name
end
