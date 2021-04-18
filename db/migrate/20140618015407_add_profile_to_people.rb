class AddProfileToPeople < ActiveRecord::Migration[4.2]
  def change
    add_column :people, :homepage_url, :string
    add_column :people, :fb_profile_url, :string
    add_column :people, :fb_page_url, :string
  end
end
