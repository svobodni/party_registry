class AddConfirmableToDevise < ActiveRecord::Migration[4.2]
  def up
    add_column :people, :confirmation_token, :string
    add_column :people, :confirmed_at, :datetime
    add_column :people, :confirmation_sent_at, :datetime
    add_index :people, :confirmation_token, unique: true
    execute("UPDATE people SET confirmed_at = NOW()")
  end

  def down
    remove_columns :people, :confirmation_token, :confirmed_at, :confirmation_sent_at
  end
end
