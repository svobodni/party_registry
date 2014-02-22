# Třída Organization reprezentuje organizaci strany (republiku, krajské sdružení, místní pobočku)
class Organization < ActiveRecord::Base
  has_many :bodies

  include ActiveModel::ForbiddenAttributesProtection # RailsAdmin will do the job
  rails_admin do
    field :name
   end
end
