json.person do
  json.id @person.id
  json.name @person.name
  json.date_of_birth @person.date_of_birth
  json.email @person.email
  json.street @person.domestic_address_street
  json.city @person.domestic_address_city
  json.zip @person.domestic_address_zip
end
