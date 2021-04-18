class AddHomepageUrlToOrganization < ActiveRecord::Migration[4.2]
  def change
    add_column :organizations, :homepage_url, :string
  end
end
