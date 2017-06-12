if councilor.person
  if current_person
    contacts = councilor.person.contacts.accessible_by(current_ability)
  else
    contacts = councilor.person.contacts.public_visible
  end
else
  contacts=[]
end

json.council_name councilor.council_name
json.voting_party councilor.voting_party
json.person_name councilor.person_name
json.person_party councilor.person_party
json.phone contacts.detect{|c| c.contact_type=="phone"}.try(:contact)
json.email contacts.detect{|c| c.contact_type=="email"}.try(:contact)
json.homepage_url contacts.detect{|c| c.contact_type=="web"}.try(:contact)
json.photo_url councilor.person.try(:photo_url)
json.fb_profile_url contacts.detect{|c| c.contact_type=="facebook_profile"}.try(:contact)
json.fb_page_url contacts.detect{|c| c.contact_type=="facebook_page"}.try(:contact)
