class AddBankAndAddressToOrganization < ActiveRecord::Migration[4.2]
  def change
    add_column :organizations, :fio_account_number, :string
    add_column :organizations, :fio_token, :string
    add_column :organizations, :address_line, :string
  end
end
