class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :street
      t.string :city
      t.string :zip
      t.float :latitude
      t.float :longitude
      t.integer :ruian_adresni_misto_id
      t.string :ruian_adresni_misto_mestska_cast
      t.integer :addressable_id
      t.string :addressable_type

      t.timestamps
    end
  end
end
