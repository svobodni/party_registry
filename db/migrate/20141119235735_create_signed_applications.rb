class CreateSignedApplications < ActiveRecord::Migration[4.2]
  def change
    create_table :signed_applications do |t|
      t.integer :person_id
      t.attachment :scan

      t.timestamps
    end
  end
end
