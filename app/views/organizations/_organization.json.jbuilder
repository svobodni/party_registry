json.id organization.id
json.name organization.name
if organization.try(:domestic_members)
  json.members_count organization.domestic_members.count
end
if organization.try(:branches)
  json.branches_count organization.branches.count
end