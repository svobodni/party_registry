# -*- encoding : utf-8 -*-
FactoryGirl.define do
  factory :branch do
    region { Region.find_by_name("Praha") || create(:praha) }
    coordinator { create(:coordinator) }
  end
end
