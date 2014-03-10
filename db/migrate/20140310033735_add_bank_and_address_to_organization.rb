class AddBankAndAddressToOrganization < ActiveRecord::Migration
  def change
    add_column :organizations, :fio_account_number, :string
    add_column :organizations, :fio_token, :string
    add_column :organizations, :address_line, :string
  end
end
