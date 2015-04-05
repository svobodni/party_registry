# -*- encoding : utf-8 -*-
FactoryGirl.define do

  sequence :email do |n|
    "user#{n}@example.com"
  end

  factory :person do
    email
    username "test"
    password 'password'
    first_name "Jan"
    last_name "Novák"
    date_of_birth "1980-10-10"
    phone "123 456 890"
    domestic_address_street "Dlouhá 23/312"
    domestic_address_city "Starý Františkov"
    domestic_address_zip "123 98"
    association :domestic_region, factory: :praha

    factory :office_worker do
      id 342
    end
  end

end
