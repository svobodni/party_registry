json.id @person.id
json.name @person.name
json.username @person.username
json.type !@person.is_regular_member? ? "supporter" : "member"
json.status @person.is_regular? ? "valid" : "other"
json.person_status @person.status
json.email @person.email
json.photo_url @person.photo_url
json.roles @person.roles.collect{|role|  if role.body
    role.body.slug
  elsif role.branch
    "koordinator"
  end }.uniq.concat([@person.domestic_region.slug, @person.status])