json.bodies @bodies do |body|
  json.partial! 'bodies/body', body: body
  json.organization do
    json.partial! 'organizations/organization', organization: body.organization
  end
end