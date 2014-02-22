Pokud(/^jsem přihlášen do webu$/) do
  step "I send and accept JSON"
end

Když(/^odešlu požadavak na seznam členů$/) do
  step "I send a GET request to \"/people\""
end

Pak(/^by měl dostat seznam členů$/) do
  step "the response status should be \"200\""
  step "the JSON response should have \"$..first_name\" with the text \"Jiří\""
  step "the JSON response should have \"$..last_name\" with the text \"Kubíček\""
  step "the JSON response should have \"$..first_name\" with the text \"Karel\""
  step "the JSON response should have \"$..last_name\" with the text \"Zvára\""
end
