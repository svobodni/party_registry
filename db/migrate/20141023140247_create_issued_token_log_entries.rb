class CreateIssuedTokenLogEntries < ActiveRecord::Migration
  def change
    create_table :issued_token_log_entries do |t|
      t.integer :person_id
      t.datetime :issued_at
      t.string :token_id
      t.string :audience
      t.string :ip_address

      t.timestamps
    end
  end
end
