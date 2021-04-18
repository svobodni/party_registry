Když(/^existuje pobočka "([^"]*)"$/) do |name|
  Branch.find_by_name(name) || FactoryBot.create(:branch, name: name)
end
