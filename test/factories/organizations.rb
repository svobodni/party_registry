# -*- encoding : utf-8 -*-
FactoryGirl.define do

  factory :region do
    factory :praha do
      id 10
      name "Praha"
    end
    country { Country.first || create(:country) }
    after(:create) do |region, evaluator|
      region.presidium = create :presidium, name: "Krajské předsednictvo", acronym: "KrP", organization: region
    end
  end

  factory :country do
    id 1
    name "Republikové orgány"
  end

end
