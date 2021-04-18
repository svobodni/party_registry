class AddLocakableToDevise < ActiveRecord::Migration[4.2]
  def up
    add_column :people, :failed_attempts, :integer, default: 0
    add_column :people, :unlock_token, :string
    add_column :people, :locked_at, :datetime
  end

  def down
    remove_columns :people, :locked_at, :failed_attempts, :unlock_token
  end
end
