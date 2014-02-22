# Třída Role reprezentuje volenou nebo jmenovanou funkci
class Role < ActiveRecord::Base
  belongs_to :person
  belongs_to :body
  belongs_to :branch
end
