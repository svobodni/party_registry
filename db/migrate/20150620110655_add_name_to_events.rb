class AddNameToEvents < ActiveRecord::Migration[4.2]
  def change
    add_column :events, :name, :string
  end
end
