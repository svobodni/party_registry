# Třída Coordinator reprezentuje Koordinátora pobočky
class Coordinator < Role
  belongs_to :branch

  delegate :first_name, :last_name, to: :person
end
