class AddFbPageUrlToOrganization < ActiveRecord::Migration[4.2]
  def change
    add_column :organizations, :fb_page_url, :string
  end
end
