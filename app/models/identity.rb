# Třída reprezentuje identitu (fb, twitter, mojeid)
class Identity < ActiveRecord::Base
  belongs_to :person
  validates_presence_of :uid, :provider
  validates_uniqueness_of :uid, :scope => :provider
end
