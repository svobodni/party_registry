json.id body.id
json.name body.name.split('(').first
json.president do |president|
	json.partial! 'people/person', person: body.president.try(:person) if body.president
end
json.vicepresidents body.vicepresidents do |vicepresident|
  json.partial! 'people/person', person: vicepresident.try(:person) if vicepresident.person
end

json.members body.members do |member|
  if member.try(:members)
  	json.name member.members.name
  else
  	json.name member.name
  end
end 
