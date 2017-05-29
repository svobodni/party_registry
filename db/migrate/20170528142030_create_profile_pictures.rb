class CreateProfilePictures < ActiveRecord::Migration
  def change
    create_table :profile_pictures do |t|
      t.attachment :photo
      t.integer :person_id

      t.timestamps null: false
    end
  end
end
