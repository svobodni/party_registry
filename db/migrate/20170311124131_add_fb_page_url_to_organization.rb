class AddFbPageUrlToOrganization < ActiveRecord::Migration
  def change
    add_column :organizations, :fb_page_url, :string
  end
end
