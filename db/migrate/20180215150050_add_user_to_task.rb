class AddUserToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :person_id, :integer
  end
end
