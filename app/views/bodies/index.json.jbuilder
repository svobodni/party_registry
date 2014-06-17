json.bodies @bodies do |body|
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
  json.organization do |organization|
  	json.id body.organization.id
  	json.name body.organization.name
  	if body.organization.try(:domestic_members)
    	json.members_count body.organization.domestic_members.count
    end
    if body.organization.try(:branches)
    	json.branches_count body.organization.branches.count
    	json.branches body.organization.branches do |branch|
    		json.id branch.id
        json.name branch.name
    		json.members_count branch.domestic_members.count
    		json.coordinator do |coordinator|
    			json.name branch.coordinator.try(:person).try(:name)
    			json.phone branch.coordinator.try(:person).try(:phone)
    			json.email branch.coordinator.try(:person).try(:email)
    		end
    	end
    end
  end

  #json.age calculate_age(person.birthday)
end

#json.bodies do |json|
#	@bodies.each do |body|
#		json.body body, :id, :name
#	end
#end

#json.(@bodies, :id, :name, :published_at)
#json.edit_url edit_article_url(@article) if current_user.admin?
#
#json.author @article.author, :id, :name
## or 
#json.author do |json|
#  json.(@article.author, :id, :name)
#  json.url author_url(@article.author)
#end
#
#json.comments @article.comments, :id, :name, :content
## or
#json.comments @article.comments do |json, comment|
#  json.partial! comment
#end