class AddOrpToRuianAddress < ActiveRecord::Migration
  def change
    add_column :ruian_addresses, :orp, :string
    add_column :ruian_addresses, :orp_id, :integer
  end
end
