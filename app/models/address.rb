class Address < ActiveRecord::Base
  belongs_to :addressable, :polymorphic => true

  geocoded_by :address_line

  def address_line
  	"#{street}, #{zip} #{city}"
  end

end
