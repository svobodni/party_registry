class AddDisplayPositionToBody < ActiveRecord::Migration[4.2]
  def change
    add_column :bodies, :display_position, :integer
  end
end
