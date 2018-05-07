class AddCandidatesListFileIdToCandidatesList < ActiveRecord::Migration
  def change
    add_column :candidates_lists, :candidates_list_file_id, :integer
  end
end
