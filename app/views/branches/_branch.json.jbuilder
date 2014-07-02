json.id branch.id
json.name branch.name
json.members_count branch.domestic_members.count
json.coordinator do |coordinator|
  json.partial! 'people/person', person: branch.coordinator.try(:person) if branch.coordinator
end
json.recruiter do |recruiter|
  json.partial! 'people/person', person: branch.recruiter.try(:person) if branch.recruiter
end
