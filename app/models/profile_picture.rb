class ProfilePicture < ActiveRecord::Base
  has_many :events, as: :eventable

  has_attached_file :photo, styles: {legacy: "110x132#",
      tiny: "50x50#",
      medium: "330x396",
      large: "990x1188"
    }, processors: [:cropper, :thumbnail]
 #, path: ":rails_root/data/photos/:id.pdf"
  validates_attachment_content_type :photo, :content_type => ["image/jpg", "image/jpeg", "image/png"]

  before_post_process :check_file_size
  def check_file_size
    valid?
    errors[:photo_file_size].blank?
  end
end
