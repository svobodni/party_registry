class AddAmountToPerson < ActiveRecord::Migration
  def change
    add_column :people, :amount, :integer
  end
end
