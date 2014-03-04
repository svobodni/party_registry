class CreateRuianAddresses < ActiveRecord::Migration
  def change
    create_table :ruian_addresses do |t|
      t.string :mestska_cast
      t.integer :mestska_cast_id
      t.string :obec
      t.integer :obec_id
      t.string :kraj
      t.integer :kraj_id

      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
