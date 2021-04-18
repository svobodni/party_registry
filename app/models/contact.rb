class Contact < ApplicationRecord
  belongs_to :contactable, :polymorphic => true

  has_many :events, as: :eventable

  belongs_to :person,
           foreign_key: 'contactable_id'
           #conditions: "contacts.contactable_type = 'Person'"
           #includes: :contacts

  scope :public_visible, -> { where(privacy: 'public') }

  validates_presence_of :contact_type
  validates_presence_of :contact
  validates_presence_of :privacy


  validates :contact, :presence => true,
                    :format => {:with => /\A[0-9\-\+ ]{9,15}\z/},
                    :length => { :minimum => 9, :maximum => 15 },
                    :if => Proc.new { |o| o.contact_type == "phone"}

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
      ['Fórum - kandidátské vlákno','forum'],
      ['FB stránka','facebook_page'],
      ['Linked in','linked_in'],
      ['Skype','skype']
    ]
  end
end
