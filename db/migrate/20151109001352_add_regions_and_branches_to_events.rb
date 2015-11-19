class AddRegionsAndBranchesToEvents < ActiveRecord::Migration
  def change
    add_column :events, :old_domestic_region_id, :integer
    add_column :events, :old_domestic_branch_id, :integer
    add_column :events, :domestic_region_id, :integer
    add_column :events, :domestic_branch_id, :integer
    add_column :events, :old_guest_region_id, :integer
    add_column :events, :old_guest_branch_id, :integer
    add_column :events, :guest_region_id, :integer
    add_column :events, :guest_branch_id, :integer
  end
end
