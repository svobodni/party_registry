Když(/^existuje pobočka "([^"]*)"$/) do |name|
  FactoryGirl.create(:branch, :name => name)
end
