json.region do
  json.partial! 'organizations/organization', organization: @region
  json.presidium do
	json.partial! 'bodies/body',  body: @region.presidium
  end
  json.branches do
  	json.partial! 'branches/branch', collection: @region.branches, as: :branch
  end
 end
