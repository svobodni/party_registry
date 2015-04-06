Když(/^existuje pobočka "([^"]*)"$/) do |name|
  Branch.find_by_name(name) || FactoryGirl.create(:branch, name: name)
end
