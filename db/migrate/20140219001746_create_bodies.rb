class CreateBodies < ActiveRecord::Migration
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
