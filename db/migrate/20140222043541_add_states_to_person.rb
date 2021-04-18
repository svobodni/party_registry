class AddStatesToPerson < ActiveRecord::Migration[4.2]
  def change
    add_column :people, :member_status, :string
    add_column :people, :supporter_status, :string
  end
end
