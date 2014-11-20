require "crack"

PaperTrail.whodunnit = 'Importer'

def import_person(type, member)
  id = member["membership"]["variableSymbol"][1..-1]
  person = Person.find_or_initialize_by(id: id)
  person.legacy_type = type.to_s

  person.name_prefix = member["personalData"]["degreeBeforeName"]  
  person.first_name = member["personalData"]["firstName"].strip
  person.last_name = member["personalData"]["lastName"]
  person.name_suffix = member["personalData"]["degreeAfterName"]

  person.email = member["contact"]["email"]
  person.public_email = member["contact"]["publicEmail"]
  person.phone = member["contact"]["phone"]
  person.phone_public = member["contact"]["isPhonePublic"]=="True"
  
  person.username=member["login"]["userName"]
  person.encrypted_password = member["login"]["passwordHash"]
  person.password_salt=member["login"]["passwordSalt"]

  person.birth_number = member["personalData"]["birthCertificateNumber"]
  person.date_of_birth = Time.strptime(member["personalData"]["birthDate"],"%m/%d/%Y %r") unless member["personalData"]["birthDate"].empty? 
  person.previous_political_parties=member["membership"]["politicalParties"]
 
  person.domestic_region_id=member["contact"]["districtId"]
  person.guest_region_id=member["membership"]["guestDistrictId"]
 
  person.domestic_address_street = member["contact"]["street"]
  person.domestic_address_city = member["contact"]["town"]
  person.domestic_address_zip = member["contact"]["postalCode"]

  person.photo_url = member["web"]["photoURL"]
  person.homepage_url = 'http://'+member["web"]["homepage"] unless member["web"]["homepage"].blank? 
  person.fb_profile_url = member["web"]["facebookProfileURL"]
  person.fb_page_url = member["web"]["facebookPageURL"]


  unless member["contact"]["actualStreet"].blank?
    person.postal_address_street = member["contact"]["actualStreet"]
    person.postal_address_city = member["contact"]["actualTown"]
    person.postal_address_zip = member["contact"]["actualPostalCode"]
  end
  if type==:member
    if member["membership"]["approvedByBoard"]=="True"
      if member["membership"]["paymentAccepted"]=="True"
        person.member_status="regular"
      else
        person.member_status="awaiting_first_payment"
      end
    else
      person.member_status="awaiting_presidium_decision"
    end   
  else
    if member["membership"]["paymentAccepted"]=="True"
      person.supporter_status="regular"
    else
      person.supporter_status="registered"
    end
  end
  print "."
  if person.changed?
    puts ''
    puts person.changes 
    person.save!
  end
end

puts "LOADING OLD DATA"
known = Crack::XML.parse(File.open("data/old_export.xml").read)
puts "LOADING NEW DATA"
data = Crack::XML.parse(File.open("data/last_export.xml").read)

puts "IMPORT - MEMBERS"
puts data["users"]["member"].size
(data["users"]["member"]-known["users"]["member"]).each do |member|
  import_person(:member, member)
end

puts "IMPORT - SUPPORTERS"
puts data["users"]["sympathizer"].size
(data["users"]["sympathizer"]-known["users"]["sympathizer"]).each do |member|
  import_person(:sympathizer, member)
end

puts "DELETING"
ids = data["users"]["member"].collect{|m| m["membership"]["variableSymbol"][1..-1].to_i} + data["users"]["sympathizer"].collect{|m| m["membership"]["variableSymbol"][1..-1].to_i}
ids_to_delete = Person.all.collect(&:id)-ids

# Pokud je jich mene nez 10, jsou zruseni automaticky
if ids_to_delete.size < 265
  ids_to_delete.each{|id|
    puts "Destroying #{id}"
    Person.find(id).destroy
  }
else
  puts "Should destroy #{ids_to_delete.join(', ')}"
end 

puts "Central DB: #{data['users']['member'].size+data['users']['sympathizer'].size}"
puts "Our DB: #{Person.count}"

File.rename("data/last_export.xml","data/old_export.xml")
