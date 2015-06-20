class AddDisplayPositionToBody < ActiveRecord::Migration
  def change
    add_column :bodies, :display_position, :integer
  end
end
