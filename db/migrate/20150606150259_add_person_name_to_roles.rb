class AddPersonNameToRoles < ActiveRecord::Migration[4.2]
  def change
    add_column :roles, :person_name, :string
  end
end
