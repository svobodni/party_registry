class AddOkresToRuianAddress < ActiveRecord::Migration
  def change
    add_column :ruian_addresses, :okres, :string
    add_column :ruian_addresses, :okres_id, :integer
  end
end
