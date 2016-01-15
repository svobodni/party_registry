json.id body.id
json.name body.name.split('(').first
json.president do |president|
	json.partial! 'people/person', person: body.president.try(:person) if body.president
	json.department body.president.try(:department)
end
json.vicepresidents body.vicepresidents do |vicepresident|
  json.partial! 'people/person', person: vicepresident.try(:person) if vicepresident.person
	json.department vicepresident.try(:department)
end

json.members body.members do |member|
  if member.try(:members)
    json.partial! 'people/person', person: member.members
  else
    json.partial! 'people/person', person: member
  end
end
