class AddDepartmentToRole < ActiveRecord::Migration[4.2]
  def change
    add_column :roles, :department, :string
  end
end
