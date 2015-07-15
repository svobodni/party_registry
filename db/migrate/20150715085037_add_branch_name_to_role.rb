class AddBranchNameToRole < ActiveRecord::Migration
  def change
    add_column :roles, :branch_name, :string
  end
end
