class CreateIdentities < ActiveRecord::Migration[4.2]
  def change
    create_table :identities do |t|
      t.string :uid
      t.string :provider
      t.references :person, index: true

      t.timestamps
    end
  end
end
