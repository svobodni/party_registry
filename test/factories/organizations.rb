# -*- encoding : utf-8 -*-
FactoryGirl.define do

  factory :region do
    factory :praha do
      id 10
      name "Praha"
    end
    country { Country.first || create(:country) }
    association :presidium, name: "Krajské předsednictvo", acronym: "KrP"
  end

  factory :country do
    id 1
    name "Republikové orgány"
  end

end
