Když(/^přijdu na domovskou stránku$/) do
  visit root_path
end

Když(/^jdu na stránku profilu$/) do
  visit profiles_path
end

Když(/^přejdu z domovské stránky na stránku pro přihlášení$/) do
  visit root_path
  click_link 'přihlaste'

  assert_equal new_user_session_path, current_path
end

Když(/^přejdu z domovské stránky na stránku pro registraci$/) do
  visit root_path
  click_link 'přihlaste'
  click_link 'Registrace'

  assert_equal new_user_registration_path, current_path
end

Když(/^v menu zvolím "(.*?)"$/) do |link|
  click_link link
end

Když(/^v menu rozbalím "(.*?)" a pak zvolím "(.*?)"$/) do |link1, link2|
  click_link link1

  within('//li[@class="dropdown open"]') do
    click_link link2
  end
end

A(/^zvolím "(.*?)" ze sekce "(.*?)"$/) do |link, heading|
  within("//h2[normalize-space(text())='#{heading}']/following-sibling::ul[1]") do
    click_link link
  end
end
