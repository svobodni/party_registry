# Třída Country reprezentuje republikovou úroveň
class Country < Organization
  has_many :regions, :foreign_key => "parent_id"

  include ActiveModel::ForbiddenAttributesProtection # RailsAdmin will do the job
  rails_admin do
    field :name
  end

end
