# -*- encoding : utf-8 -*-
FactoryGirl.define do

  #sequence :email do |n|
  #  "user#{n}@example.com"
  #end

  factory :role do
    person { FactoryGirl.create(:person) }

    factory :regional_president do
      type 'President'
      region { FactoryGirl.create(:region) }
    end
  end

end
