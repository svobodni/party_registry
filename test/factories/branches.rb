# -*- encoding : utf-8 -*-
FactoryBot.define do
  factory :branch do
    region { Region.find_by_name("Praha") || create(:praha) }
    after(:create) do |branch, evaluator|
      #branch.coordinator = 
      create(:coordinator, branch: branch)
    end
    factory :praha_7 do
      name { "Praha 7" }
    end
  end
end
