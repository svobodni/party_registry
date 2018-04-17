class AddAssignedAtFinishedAtReviewedAtToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :assigned_at, :datetime
    add_column :tasks, :finished_at, :datetime
    add_column :tasks, :reviewed_at, :datetime
  end
end

