class CreateSignedApplications < ActiveRecord::Migration
  def change
    create_table :signed_applications do |t|
      t.integer :person_id
      t.attachment :scan

      t.timestamps
    end
  end
end
