class AddPreviousCandidaturesToPeople < ActiveRecord::Migration[4.2]
  def change
    add_column :people, :previous_candidatures, :text
  end
end
