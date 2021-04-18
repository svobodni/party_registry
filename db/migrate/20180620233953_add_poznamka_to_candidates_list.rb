class AddPoznamkaToCandidatesList < ActiveRecord::Migration[4.2]
  def change
    add_column :candidates_lists, :poznamka, :string
  end
end
