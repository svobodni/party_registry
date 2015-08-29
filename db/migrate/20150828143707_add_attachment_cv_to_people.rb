class AddAttachmentCvToPeople < ActiveRecord::Migration
  def self.up
    change_table :people do |t|
      t.attachment :cv
    end
  end

  def self.down
    remove_attachment :people, :cv
  end
end
