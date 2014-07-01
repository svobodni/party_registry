json.id organization.id
json.name organization.name
if organization.try(:domestic_members)
	json.members_count organization.domestic_members.count
end
if organization.try(:branches)
	json.branches_count organization.branches.count
	json.branches organization.branches do |branch|
		json.id branch.id
    json.name branch.name
		json.members_count branch.domestic_members.count
		json.coordinator do |coordinator|
			json.name branch.coordinator.try(:person).try(:name)
			json.phone branch.coordinator.try(:person).try(:phone)
			json.email branch.coordinator.try(:person).try(:email)
		end
    json.recruiter do |recruiter|
      json.name branch.recruiter.try(:person).try(:name)
      json.phone branch.recruiter.try(:person).try(:phone)
      json.email branch.recruiter.try(:person).try(:email)
    end
	end
end