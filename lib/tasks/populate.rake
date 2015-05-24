# -*- encoding : utf-8 -*-

namespace :db do
  desc "Insert development data"
  task :populate => :environment do
    # vytvoření běžného člena
    regular_member = Person.create!(
      status: "regular_member",
      username: "janclen",
      password: "mojeheslo",
      first_name: "Jan",
      last_name: "Členovský",
      email: "clenovsky@svobodnitest.cz",
      date_of_birth: "1970-01-01",
      domestic_address_street: "Uliční 234",
      domestic_address_city: "Praha",
      domestic_address_zip: "123 45",
      phone: "123456789",
      domestic_region_id: 10,
      amount: 1000,
      agree: "1",
      confirmed_at: Time.now
    )
  end
end
