# Třída Role reprezentuje volenou nebo jmenovanou funkci
class Role < ActiveRecord::Base
  # kdo funkci vykonává
  belongs_to :person
  # v jakém orgánu?
  belongs_to :body
  # /nebo/ v jaké pobočce
  belongs_to :branch

  def name
  	person.try(:name)
  end

end
