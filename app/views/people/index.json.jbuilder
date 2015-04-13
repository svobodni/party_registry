json.people @people do |person|
  json.id person.id
  json.vs person.vs
  json.type person.is_member? ? "member" : "sympathizer"
  json.person_type person.is_member? ? "member" : "supporter"
  json.status person.status
  json.member_status person.member_status
  json.supporter_status person.supporter_status
  json.name person.name
  json.first_name person.first_name
  json.last_name person.last_name
  json.email person.email
  json.phone person.phone
  json.domestic_address do
    json.latitude person.domestic_ruian_address.try(:latitude)
    json.longitude person.domestic_ruian_address.try(:longitude)
  end
  json.domestic_region do
    json.id person.domestic_region_id
    json.name person.domestic_region.name
  end
  json.domestic_branch do
    json.id person.domestic_branch_id
    json.name person.domestic_branch.try(:name)
  end
  json.guest_region do
    json.id person.guest_region_id
    json.name person.guest_region.try(:name)
  end if person.guest_region
  json.guest_branch do
    json.id person.guest_branch_id
    json.name person.guest_branch.try(:name)
  end if person.guest_branch
end
