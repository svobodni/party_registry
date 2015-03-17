class Contact < ActiveRecord::Base
  belongs_to :contactable, :polymorphic => true

  belongs_to :person,
           foreign_key: 'contactable_id'
           #conditions: "contacts.contactable_type = 'Person'"
           #includes: :contacts

  scope :public_visible, -> { where(privacy: 'public') }

  validates_presence_of :contact_type
  validates_presence_of :contact
  validates_presence_of :privacy


  def self.privacies
    [
      ['Veřejný kontakt','public'],
      ['Jen pro členy a příznivce','supporters'],
      ['Jen pro členy','members'],
      ['Jen pro orgány a koordinátora','coordinator'],
      ['Jen pro orgány','regional']
    ]
  end

  def self.types
    [
      ['Telefon', 'phone'],
      ['Email','email'],
      ['FB profil','facebook_profile'],
      ['Twitter','twitter'],
      ['Google+','google_plus'],
      ['Web','web'],
      ['Blog','blog'],
      ['FB stránka','facebook_page'],
      ['Linked in','linked_in']
    ]
  end
end
