json.region do
  json.partial! 'organizations/organization', organization: @region
  json.body do
	json.partial! 'bodies/body',  body: @region.presidium
  end
end
