class Councilor < ActiveRecord::Base
  belongs_to :region
  belongs_to :person

  scope :regional, -> { where(council_type: 'regional') }
  scope :municipal, -> { where(council_type: 'municipal') }
end
