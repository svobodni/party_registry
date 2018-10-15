json.payment do
  json.id @person.id
  json.name @person.name
  json.street @person.domestic_address_street
  json.city @person.domestic_address_city
  json.zip @person.domestic_address_zip
  json.email @person.email
  json.date_of_birth @person.date_of_birth
end
