json.branch do 
  json.id @branch.id
  json.name @branch.name
  json.members_count @branch.domestic_members.count
  json.coordinator do |coordinator|
    json.name @branch.coordinator.try(:person).try(:name)
    json.phone @branch.coordinator.try(:person).try(:phone)
    json.email @branch.coordinator.try(:person).try(:email)
  end
  json.recruiter do |recruiter|
    json.name @branch.recruiter.try(:person).try(:name)
    json.phone @branch.recruiter.try(:person).try(:phone)
    json.email @branch.recruiter.try(:person).try(:email)
  end
end
