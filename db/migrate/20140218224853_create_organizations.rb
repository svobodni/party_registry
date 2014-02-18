class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :type
      t.string :name
      t.integer :parent_id

      t.timestamps
    end
  end
end
