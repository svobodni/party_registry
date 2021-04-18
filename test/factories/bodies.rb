# -*- encoding : utf-8 -*-
FactoryBot.define do
  factory :body do
    factory :presidium do
      after(:create) do |presidium, evaluator|
        presidium.president = create :president, body: presidium
      end
    end
    factory :country_bodies do
      factory :rep do
        id 1
        name "Republikové předsednictvo"
        acronym "ReP"
      end
      factory :vk do
        id 3
        name "Volební komise"
        acronym "VK"
      end
      factory :rk do
        name "Rozhodčí komise"
        acronym "RK"
      end
      organization { Country.first || create(:country) }
    end
  end
end
