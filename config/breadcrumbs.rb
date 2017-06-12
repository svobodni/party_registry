crumb :root do
  link "Registr", root_path
end

crumb :regions do
  link "Kraje", regions_path
end

crumb :people do
  link "Lidé"
end

crumb :bodies do
  link "Orgány"
end

crumb :body do |body|
  link body.name
  parent :bodies
end

crumb :person do |person|
  link person.name, person_path(person)
  parent :people
end

crumb :profile do
  link current_person.name, profiles_path
  parent :root
end

crumb :profile_guesting do
  link "Hostování", guesting_profiles_path
  parent :profile
end

crumb :profile_membership do
  link "Členství", membership_profiles_path
  parent :profile
end

crumb :region do |region|
  link region.name, region_path(region)
  parent :regions
  #parent :root
end

crumb :region_presidium do |region|
  link "Předsednictvo" #, region_branches_path(region)
  parent :region, region
end

crumb :region_branches do |region|
  link "Pobočky" #, region_branches_path(region)
  parent :region, region
end

crumb :region_contacts do |region|
  link "Sdílené kontakty", region_contacts_path(region)
  parent :region, region
end

crumb :region_councilors do |region|
  link "Zastupitelé", region_contacts_path(region)
  parent :region, region
end

crumb :region_mestske_casti do |region|
  link "Městské části", mestske_casti_region_path(region)
  parent :region, region
end

crumb :region_okresy do |region|
  link "Okresy", okresy_region_path(region)
  parent :region, region
end

crumb :branch do |branch|
  link branch.name, branch_path(branch)
  parent :region_branches, branch.region
end

crumb :branch_contacts do |branch|
  link "Sdílené kontakty", branch_contacts_path(branch)
  parent :branch, branch
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
