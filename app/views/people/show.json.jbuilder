json.person do
  json.id @person.id
  json.name @person.name
  json.photo_url @person.photo_url
  json.cv_url @person.cv_url
  json.contacts @person.contacts.accessible_by(current_ability) do |contact|
    json.type contact.contact_type
    json.value contact.contact
  end
end
