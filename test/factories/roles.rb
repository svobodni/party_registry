# -*- encoding : utf-8 -*-
FactoryGirl.define do

  factory :coordinator do
    person{ create(:person) }
    since { 6.months.ago }
    till { 1.year.since }
  end

  factory :president do
    person { create(:person) }
    since { 6.months.ago }
    till { 1.year.since }
  end

end
