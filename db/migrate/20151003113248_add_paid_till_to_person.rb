class AddPaidTillToPerson < ActiveRecord::Migration
  def change
    add_column :people, :paid_till, :date
  end
end
