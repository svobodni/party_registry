class AddOkresToRuianAddress < ActiveRecord::Migration[4.2]
  def change
    add_column :ruian_addresses, :okres, :string
    add_column :ruian_addresses, :okres_id, :integer
  end
end
