json.region do
  json.partial! 'organizations/organization', organization: @region
  json.presidium do
	   json.partial! 'bodies/body',  body: @region.presidium
  end
  json.branches do
  	json.partial! 'branches/branch', collection: @region.branches, as: :branch
  end
  json.regional_councilors do
    json.partial! 'councilors/councilor', collection: @region.councilors.regional, as: :councilor
  end
  json.municipal_councilors do
    json.partial! 'councilors/councilor', collection: @region.councilors.municipal, as: :councilor
  end
 end
