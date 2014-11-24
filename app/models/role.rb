# -*- encoding : utf-8 -*-
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

  def role_name
    role = case self.class.to_s
    when "President"
      "Předseda"
    when "Vicepresident"
      "Místopředseda"
    when "Member"
      "Člen"
    when "Coordinator"
      "Koordinátor"
    else  self.class.to_s
    end
  	"#{role} #{body.try(:acronym) || branch.try(:name)}"
  end

end
