class AddRegionAndBranchToPerson < ActiveRecord::Migration[4.2]
  def change
    add_column :people, :domestic_region_id, :integer
    add_column :people, :guest_region_id, :integer
    add_column :people, :domestic_branch_id, :integer
    add_column :people, :guest_branch_id, :integer
  end
end
