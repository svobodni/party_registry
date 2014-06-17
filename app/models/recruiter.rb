# Třída Recruiter reprezentuje Náboráře pobočky - člena odpovědného za seznamovací rozhovor
class Recruiter < Role
  belongs_to :branch

  delegate :first_name, :last_name, to: :person
end
