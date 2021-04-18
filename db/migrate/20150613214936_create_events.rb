class CreateEvents < ActiveRecord::Migration[4.2]
  def change
    create_table :events do |t|
      t.string :uuid
      t.integer :requestor_id
      t.string :eventable_type
      t.integer :eventable_id
      t.string :command
      t.text :metadata
      t.text :data

      t.timestamps
    end
  end
end
