class Councilor < ApplicationRecord
  belongs_to :region, optional: true
  belongs_to :person, optional: true

  scope :regional, -> { where(council_type: 'regional') }
  scope :municipal, -> { where(council_type: 'municipal') }
end
