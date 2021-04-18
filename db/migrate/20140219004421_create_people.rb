class CreatePeople < ActiveRecord::Migration[4.2]
  def change
    create_table :people do |t|
      t.string :name_prefix
      t.string :first_name
      t.string :last_name
      t.string :name_suffix
      t.string :birth_number
      t.date :date_of_birth
      t.string :legacy_type
      t.string :username
      t.string :phone
      t.boolean :phone_public
      t.string :public_email
      t.text :previous_political_parties

      t.string :domestic_address_street
      t.string :domestic_address_city
      t.string :domestic_address_zip
      t.integer :domestic_address_ruian_id

      t.string :postal_address_street
      t.string :postal_address_city
      t.string :postal_address_zip
      t.integer :postal_address_ruian_id

      t.string :photo_url

      t.timestamps
    end
  end
end
