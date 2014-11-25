json.partial! 'bodies/body',  body: @body
json.organization do
  json.partial! 'organizations/organization', organization: @body.organization
end
json.partial! 'branches/branch', collection: @body.organization.branches, as: :branch
