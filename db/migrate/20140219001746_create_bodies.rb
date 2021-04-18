class CreateBodies < ActiveRecord::Migration[4.2]
  def change
    create_table :bodies do |t|
      t.string :type
      t.string :name
      t.string :acronym
      t.integer :organization_id

      t.timestamps
    end
  end
end
