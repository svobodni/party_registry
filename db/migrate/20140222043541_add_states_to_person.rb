class AddStatesToPerson < ActiveRecord::Migration
  def change
    add_column :people, :member_status, :string
    add_column :people, :supporter_status, :string
  end
end
