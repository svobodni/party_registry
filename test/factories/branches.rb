# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :branch do
    #region { FactoryGirl.create(:praha) }
    association :region, name: "Praha"
  end
end
