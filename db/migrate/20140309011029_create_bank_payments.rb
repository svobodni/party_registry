class CreateBankPayments < ActiveRecord::Migration[4.2]
  def change

    create_table "bank_payments" do |t|
      t.integer  "account_id"
      t.decimal  "amount",        :precision => 10, :scale => 2
      t.string   "status"
      t.integer  "row_id"
      t.boolean  "transfer", :default => false
      t.date     "validfrom"
      t.date     "validto"
      t.string   "curcode"
      t.datetime "datum"
      t.string   "debitaccount"
      t.string   "debitbank"
      t.string   "creditaccount"
      t.string   "creditbank"
      t.string   "varsym"
      t.string   "constsym"
      t.string   "info"
      t.string   "ekonto_status"
      t.string   "accname"
      t.string   "specsym"
      t.string   "type"

      t.timestamps
    end
  end
end