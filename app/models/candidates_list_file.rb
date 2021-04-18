class CandidatesListFile < ApplicationRecord

  has_attached_file :sheet, path: ":rails_root/data/:class/:id.xlsx"
  validates_attachment :sheet, presence: true, content_type: { content_type: /\Aapplication\/.*\z/ }

end
