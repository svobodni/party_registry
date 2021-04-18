class AddAmountToPerson < ActiveRecord::Migration[4.2]
  def change
    add_column :people, :amount, :integer
  end
end
