Když(/^vyplním do "(.*?)" hodnotu "(.*?)"$/) do |field, value|
  if ['Identifikátor', 'Identifikátor nového kontaktu'].include?(field)
    value = enriched_handle(value)
  end

  begin
    fill_in(field, :with => value, :exact => true)
  rescue Capybara::ElementNotFound
    if field.match(/\A\*/)
      raise
    else
      field = '* ' + field
      retry
    end
  end
end

Když(/^nevyplním do "(.*?)" hodnotu "(.*?)"$/) do |field, value|
end

A(/^vyplním do (\d+)\. pole "(.*?)" hodnotu "(.*?)"$/) do |number, field, value|
  index = number.to_i - 1
  within("//label[normalize-space(text())='#{field}']/..") do
    page.all(:fillable_field, field)[index].set(value)
  end
end

A(/^nevyplním do (\d+)\. pole "(.*?)" hodnotu "(.*?)"$/) do |number, field, value|
end

Když(/^zvolím hodnotu "(.*?)" z "(.*?)"$/) do |value, field|
  select(value, :from => field)
end

Když(/^nezvolím hodnotu "(.*?)" z "(.*?)"$/) do |value, field|
end

A(/^stisknu (\d+)× tlačítko "(.*?)" u "(.*?)"$/) do |count, button, section|
  within("//label[normalize-space(text())='#{section}']/..") do
    count.to_i.times do
      click_button button
    end
  end
end

Když(/^stisknu tlačítko "(.*?)"$/) do |name|
  click_button name
end

Když(/^zvolím "([^"]+)"$/) do |name|
  click_link name
end

A(/^zaškrtnu "(.*?)"$/) do |name|
  check name
end

Když(/^odešlu formulář$/) do
  click_button 'Uložit'
end

Když(/^odešlu přihlašovací formulář$/) do
  click_button 'Přihlásit'
end

Když(/^odešlu registrační formulář$/) do
  click_button 'Vytvořit'
end
