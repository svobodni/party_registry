class AddAddressToPerson < ActiveRecord::Migration
  def change
    add_column :people, :registered_address_id, :integer
    add_column :people, :postal_address_id, :integer
  end
end
