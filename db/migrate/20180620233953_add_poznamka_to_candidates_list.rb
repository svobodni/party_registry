class AddPoznamkaToCandidatesList < ActiveRecord::Migration
  def change
    add_column :candidates_lists, :poznamka, :string
  end
end
