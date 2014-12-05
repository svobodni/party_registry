json.person do
  json.id @person.id
  json.name @person.name
  json.photo_url @person.photo_url
  json.cv_url @person.cv_url
  json.contacts do
  @person.contacts.accessible_by(current_ability).each do |contact|
    json.set! contact.contact_type, contact.contact
  end
  end
end

