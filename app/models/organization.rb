# Třída Organization reprezentuje organizaci strany (republiku, krajské sdružení, místní pobočku)
class Organization < ActiveRecord::Base
  has_many :bodies

  has_many :fio_payments, foreign_key: :creditaccount, primary_key: :fio_account_number

  has_many :events, as: :eventable
end
