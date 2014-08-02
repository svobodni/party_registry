json.person do
  json.name @person.name
  json.type @person.is_member? ? "member" : "supporter"
  json.first_name @person.first_name
  json.last_name @person.last_name
  json.email @person.email
  json.phone @person.phone
  json.homepage_url @person.homepage_url
  json.fb_page_url @person.fb_page_url
  json.fb_profile_url @person.fb_profile_url
  json.photo_url @person.photo_url
  json.domestic_region do
    json.name @person.domestic_region.name
  end
  json.guest_region do
    json.name @person.guest_region.name
  end if @person.guest_region
  json.domestic_branch do
    json.name @person.domestic_branch.try(:name)
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
