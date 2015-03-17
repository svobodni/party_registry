class AddPreviousCandidaturesToPeople < ActiveRecord::Migration
  def change
    add_column :people, :previous_candidatures, :text
  end
end
