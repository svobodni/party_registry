json.id body.id
json.name body.name.split('(').first
json.president do |president|
	json.name body.president.try(:person).try(:name)
end
json.vicepresidents body.vicepresidents do |vicepresident|
	json.name vicepresident.try(:person).try(:name)
end
json.members body.members do |member|
	json.name member.members.name
end
