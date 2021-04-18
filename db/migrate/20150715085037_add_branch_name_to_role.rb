class AddBranchNameToRole < ActiveRecord::Migration[4.2]
  def change
    add_column :roles, :branch_name, :string
  end
end
