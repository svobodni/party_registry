json.id organization.id
json.name organization.name
json.bank_account_number organization.fio_account_number
json.bank_code "2010"
json.homepage_url organization.homepage_url
if organization.try(:domestic_members)
  json.members_count organization.domestic_members.count
end
if organization.try(:branches)
  json.branches_count organization.branches.count
end
