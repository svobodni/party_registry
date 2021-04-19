Pak(/^(?:|měl bych|bych měl) být přesměrován na stránku (.+)$/)  do |page_title|
  assert page.has_xpath?('//h2', :text => page_title)
end

Pak /^(?:|měl bych|bych měl) vidět "([^\"]*)"$/ do |text|
  assert page.has_xpath?('//*', :text => text)
end

Pak /^(?:|neměl bych|bych neměl) vidět "([^\"]*)"$/ do |text|
end

Pak(/^měl bych vidět číslo republikového účtu$/) do
  assert page.has_xpath?('//*', :text => Country.first.members_account_number)
end

Když(/^jdu na stránku Členství$/) do
  visit membership_profiles_path
end

Když(/^se přihlásím jako zájemce o členství$/) do
  $user_id = FactoryBot.create(:registered_requesting_membership, username: 'test', password: 'testovaciheslo').id
  log_user_in('test', 'testovaciheslo')
end

Když(/^se přihlásím jako schválený zájemce o členství$/) do
  $user_id = FactoryBot.create(:registered_requesting_membership_approved, username: 'test', password: 'testovaciheslo').id
  log_user_in('test', 'testovaciheslo')
end

Když(/^se přihlásím jako zájemce o členství s nahranou přihláškou$/) do
  $user_id = FactoryBot.create(:registered_requesting_membership_with_signed_application, username: 'test', password: 'testovaciheslo').id
  log_user_in('test', 'testovaciheslo')
end

Když(/^se přihlásím jako schválený zájemce o členství s nahranou přihláškou$/) do
  $user_id = FactoryBot.create(:registered_requesting_membership_approved_with_application, username: 'test', password: 'testovaciheslo').id
  log_user_in('test', 'testovaciheslo')
end

Když(/^se přihlásím jako řádný člen bez nahrané přihlášky$/) do
  $user_id = FactoryBot.create(:person, username: 'test', password: 'testovaciheslo', status: "regular_member").id
  log_user_in('test', 'testovaciheslo')
end
