class AddPaidTillToPerson < ActiveRecord::Migration[4.2]
  def change
    add_column :people, :paid_till, :date
  end
end
