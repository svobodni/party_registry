class AddAttachmentCvToPeople < ActiveRecord::Migration[4.2]
  def self.up
    change_table :people do |t|
      t.attachment :cv
    end
  end

  def self.down
    remove_attachment :people, :cv
  end
end
