json.id organization.id
json.name organization.name
json.homepage_url organization.homepage_url
# if organization.try(:domestic_members)
#   json.members_count organization.domestic_members.count
# end
if organization.try(:branches)
  json.branches_count organization.branches.count
end
