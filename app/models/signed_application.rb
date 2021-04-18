class SignedApplication < ApplicationRecord
  belongs_to :person

  has_attached_file :scan, path: ":rails_root/data/signed_applications/:person_id.pdf", url: "/people/:person_id/signed_application.pdf"
  validates_attachment :scan, presence: true, content_type: { content_type: ["application/pdf", "application/vnd.ms-excel"] }

  validates :person, uniqueness: true, presence: true

  # interpolate in paperclip
  Paperclip.interpolates :person_id  do |attachment, style|
    attachment.instance.person_id
  end
end
