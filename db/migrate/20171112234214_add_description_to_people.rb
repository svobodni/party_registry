class AddDescriptionToPeople < ActiveRecord::Migration[4.2]
  def change
    add_column :people, :description, :text
  end
end
