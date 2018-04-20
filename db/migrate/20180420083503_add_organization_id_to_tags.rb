class AddOrganizationIdToTags < ActiveRecord::Migration
  def change
    add_column :tags, :organization_id, :integer
  end
end
