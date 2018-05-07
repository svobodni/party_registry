class CreateCandidatesListFiles < ActiveRecord::Migration
  def change
    create_table :candidates_list_files do |t|
      t.string :sheet_file_name
      t.string :sheet_content_type
      t.integer :sheet_file_size
      t.datetime :sheet_updated_at

      t.timestamps null: false
    end
  end
end
