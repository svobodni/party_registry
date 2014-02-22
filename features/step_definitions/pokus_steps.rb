Pokud(/^přijde listinná přihláška$/) do
  step "I authenticate as the user \"joe\" with the password \"password123\""
end

Když(/^odešlu informaci o jejím přijetí$/) do
  step "I send a GET request to \"/people\""
end

Pak(/^by měl zájemce čekat na rozhodnutí KrP o přijetí$/) do
  Person.first.status=="waiting"
end
