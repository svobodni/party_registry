# Třída Organization reprezentuje organizaci strany (republiku, krajské sdružení, místní pobočku)
class Organization < ActiveRecord::Base
  has_many :bodies

  has_many :fio_payments, foreign_key: :creditaccount, primary_key: :fio_account_number
  include ActiveModel::ForbiddenAttributesProtection # RailsAdmin will do the job
  rails_admin do
    field :name
   end
end
