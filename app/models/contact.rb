class Contact < ActiveRecord::Base
  belongs_to :contactable, :polymorphic => true

  belongs_to :person, 
           foreign_key: 'contactable_id'
           #conditions: "contacts.contactable_type = 'Person'"
           #includes: :contacts
end
