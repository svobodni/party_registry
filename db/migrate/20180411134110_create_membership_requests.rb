class CreateMembershipRequests < ActiveRecord::Migration
  def change
    create_table :membership_requests do |t|
      t.integer :person_id
      t.string :previous_status
      t.date :membership_requested_on
      t.date :application_received_on
      t.date :approved_on
      t.date :paid_on

      t.timestamps null: false
    end
  end
end
