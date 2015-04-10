# -*- encoding : utf-8 -*-
FactoryGirl.define do

  sequence :email do |n|
    "user#{n}@example.com"
  end

  sequence :username do |n|
    "user#{n}"
  end

  factory :person do
    email
    username
    password 'password'
    first_name "Jan"
    last_name "Novák"
    date_of_birth "1980-10-10"
    phone "123 456 890"
    domestic_address_street "Dlouhá 23/312"
    domestic_address_city "Starý Františkov"
    domestic_address_zip "123 98"
    domestic_region { Region.find_by_name("Praha") || create(:praha) }

    factory :member_awaiting_decision do
      member_status :awaiting_presidium_decision
    end

    factory :signed_member_awaiting_decision do
      member_status :awaiting_presidium_decision
      signed_application
    end

    factory :member_awaiting_first_payment do
      member_status :awaiting_first_payment
      signed_application
    end

    factory :party_member do
      member_status :regular
      signed_application
    end

    factory :supporter do
      legacy_type "supporter"
    end

    factory :office_worker do
      id 342
    end

    factory :signed_person do
      signed_application
    end

  end

  factory :signed_application do
    person
    scan_file_name { 'test.pdf' }
    scan_content_type { 'application/pdf' }
    scan_file_size { 1024 }
  end

end
