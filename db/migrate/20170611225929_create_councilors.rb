class CreateCouncilors < ActiveRecord::Migration
  def change
    create_table :councilors do |t|
      t.string :council_name
      t.string :voting_party
      t.string :person_name
      t.string :person_party
      t.integer :person_id
      t.integer :region_id
      t.date :since
      t.date :till

      t.timestamps null: false
    end
  end
end
