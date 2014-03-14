# -*- encoding : utf-8 -*-
class FioPayment < BankPayment
  #unloadable

  before_create :set_transfer
  validate unique: :row_id

  def set_transfer
    self.transfer = true
  end

  def self.account_currency
    'CZK'
  end

  def self.import
    list = FioAPI::List.new
    list.from_last_fetch

    response = list.response
    response.transactions.each do |row|

      unless is_imported?(row)

        fio_payment = create!(
          :amount => row.amount,
          :datum => Date.parse(row.date),
          :curcode => row.currency,
          :row_id => row.transaction_id,
          :debitaccount => row.account,
          :debitbank => row.bank_code,
          :creditaccount => response.account.account_id,
          :creditbank => response.account.bank_id,
          :varsym => row.vs || '',
          :constsym => row.ks || '',
          :specsym => row.ss || '',
          :info => row.message_for_recipient || '',
          :accname => row.user_identification || '',
        )

        #fio_payment.close!
      end

    end
  end

  private

  def self.is_imported?(payment)
    !find_by_row_id(payment.transaction_id).blank?
  end
end
