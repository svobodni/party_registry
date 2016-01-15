class AddDepartmentToRole < ActiveRecord::Migration
  def change
    add_column :roles, :department, :string
  end
end
