class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :type
      t.integer :person_id
      t.integer :body_id
      t.integer :branch_id
      t.date :since
      t.date :till

      t.timestamps
    end
  end
end
