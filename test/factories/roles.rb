# -*- encoding : utf-8 -*-
FactoryGirl.define do

  #sequence :email do |n|
  #  "user#{n}@example.com"
  #end

  factory :coordinator do
    person { create(:person) }

#    factory :regional_president do
#      type 'President'
#      region { Region.first || create(:region) }
#    end

  end



end
