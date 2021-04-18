class AddSlugToBodies < ActiveRecord::Migration[4.2]
  def change
    add_column :bodies, :slug, :string
    add_index :bodies, :slug, unique: true
  end
end
