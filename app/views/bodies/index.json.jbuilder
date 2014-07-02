json.bodies @bodies do |body|
  json.partial! 'bodies/body', body: body
  json.organization do
    json.partial! 'organizations/organization', organization: body.organization
    json.partial! 'branches/branch', collection: body.organization.branches, as: :branch if body.organization.respond_to?(:branches)
  end
end