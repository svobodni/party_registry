class AddCandidatesListFileIdToCandidatesList < ActiveRecord::Migration[4.2]
  def change
    add_column :candidates_lists, :candidates_list_file_id, :integer
  end
end
