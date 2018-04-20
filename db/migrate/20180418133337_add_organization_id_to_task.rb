class AddOrganizationIdToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :organization_id, :integer
  end
end
