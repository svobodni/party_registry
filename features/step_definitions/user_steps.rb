Pokud(/^existuje uživatel s přihlašovací jménem "(.*?)" a heslem "(.*?)"$/) do |username, password|
  create_user(username, password)
end

Pokud(/^existuje člen s přihlašovací jménem "(.*?)" a heslem "(.*?)"$/) do |username, password|
  $user_id = FactoryGirl.create(:person, username: username, password: password, member_status: "regular").id
end

Pokud(/^existuje přijatý zájemce o členství s přihlašovací jménem "(.*?)" a heslem "(.*?)"$/) do |username, password|
  $user_id = FactoryGirl.create(:person, username: username, password: password, member_status: "awaiting_first_payment").id
end

Pak(/^bych měl být úspešně přihlášen$/) do
  assert page.has_xpath?('//*', :text => 'Přihlášení úspěšné.')
end

Pak(/^bych měl být úspešně zaregistrován a přihlášen$/) do
  assert page.has_xpath?('//*', :text => 'Registrace byla úspěšná.')
end

Pak(/^(?:|měl bych|bych měl) vidět dashboard$/) do
  assert page.has_xpath?('//h1', :text => 'Hlavní rozcestník')
end

def create_user(username, password)
  $user_id = FactoryGirl.create(:person, username: username, password: password).id
end

Pak(/^bych měl být zařazen jako hostující do pobočky "([^"]*)"$/) do |name|
  Person.find($user_id).guest_branch.name == name
end

A(/^měl bych být zařazen jako hostující do kraje, ve kterém je pobočka "([^"]*)"$/) do |name|
  Person.find($user_id).guest_region.name == Branch.find_by_name(name).region.name
end

def log_user_in(username, password)
  visit new_person_session_path
  fill_in('person_username', :with => username)
  fill_in('heslo', :with => password)
  click_button 'Přihlásit'

  assert page.has_xpath?('//*', :text => 'Přihlášení úspěšné.')
end

Když(/^jsem přihlášen$/) do
  email, pass = 'test', 'testovaciheslo'

  create_user(email, pass)

  log_user_in(email, pass)
end

Pak(/^bych měl být úspešně odhlášen$/) do
  assert page.has_xpath?('//*', :text => 'Odhlášení úspěšné.')
end
