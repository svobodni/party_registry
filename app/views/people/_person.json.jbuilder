if current_person
  contacts = person.contacts.accessible_by(current_ability)
else
  contacts = person.contacts.public_visible
end

json.name person.name
json.phone contacts.detect{|c| c.contact_type=="phone"}.try(:contact)
json.email contacts.detect{|c| c.contact_type=="email"}.try(:contact)
json.homepage_url contacts.detect{|c| c.contact_type=="web"}.try(:contact)
json.photo_url person.photo_url
json.fb_profile_url contacts.detect{|c| c.contact_type=="facebook_profile"}.try(:contact)
json.fb_page_url contacts.detect{|c| c.contact_type=="facebook_page"}.try(:contact)
