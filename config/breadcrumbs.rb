crumb :root do
  link "Home", root_path
end

crumb :regions do
  link "Kraje", regions_path
end

crumb :people do
  link "Lidé", people_path
end

crumb :person do |person|
  link person.name, person_path(person)
  parent :people
end

crumb :region do |region|
  link region.name, region_path(region)
  #parent :regions
  parent :root
end

crumb :region_branches do |region|
  link "Pobočky", region_branches_path(region)
  parent :region, region
end

crumb :branch do |branch|
  link branch.name, branch_path(branch)
  #parent :region_branches, branch.region
  parent :region, branch.region
end

# crumb :project_issues do |project|
#   link "Issues", project_issues_path(project)
#   parent :project, project
# end

# crumb :issue do |issue|
#   link issue.title, issue_path(issue)
#   parent :project_issues, issue.project
# end

# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).