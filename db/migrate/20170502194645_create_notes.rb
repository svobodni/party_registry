class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.string :noteable_type
      t.integer :noteable_id
      t.text :content
      t.integer :created_by

      t.timestamps null: false
    end
  end
end
