json.person do
  json.id @person.id
  json.name @person.name
  json.type !@person.is_regular_member? ? "supporter" : "member"
  json.status @person.is_regular? ? "valid" : "other"
  json.person_status @person.status
  json.member_status @person.member_status
  json.supporter_status @person.supporter_status
  json.first_name @person.first_name
  json.last_name @person.last_name
  json.email @person.email
  json.photo_url @person.photo_url
  json.cv_url @person.cv_url
  json.description @person.description
  json.contacts @person.contacts.accessible_by(current_ability) do |contact|
    json.type contact.contact_type
    json.value contact.contact
  end
  json.domestic_region do
    json.name @person.domestic_region.name
    json.id @person.domestic_region.id
  end
  json.guest_region do
    json.name @person.guest_region.name
    json.id @person.guest_region.id
  end if @person.guest_region
  json.domestic_branch do
    json.name @person.domestic_branch.try(:name)
    json.id @person.domestic_branch.try(:id)
  end
  json.roles @person.roles do |role|
    json.name role.type
    json.organization do
      if role.body
        json.id role.body.id
        json.name role.body.name
      elsif role.branch
        json.id role.branch.id
        json.type role.branch.type.underscore
        json.name role.branch.name
      end
    end
  end
end
