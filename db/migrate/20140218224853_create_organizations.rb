class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :type
      t.string :name
      t.integer :parent_id

      # for regions
      t.integer :ruian_vusc_id
      t.string :nuts3_id

      t.timestamps
    end
  end
end
