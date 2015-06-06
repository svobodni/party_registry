class AddPersonNameToRoles < ActiveRecord::Migration
  def change
    add_column :roles, :person_name, :string
  end
end
