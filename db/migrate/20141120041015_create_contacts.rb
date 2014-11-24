class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :contactable_type
      t.integer :contactable_id
      t.string :contact_type
      t.string :contact
      t.string :privacy

      t.timestamps
    end
  end
end
