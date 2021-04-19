# -*- encoding : utf-8 -*-
FactoryBot.define do

  factory :region do
    factory :praha do
      id {10}
      name {"Praha"}
    end
    country { Country.first || create(:country) }
    after(:create) do |region, evaluator|
      region.presidium = create :presidium, name: "Krajské předsednictvo", acronym: "KrP", organization: region
    end
  end

  factory :country do
    id {1}
    name {"Republikové orgány"}
    fio_account_number {"123456789"}
  end

end
