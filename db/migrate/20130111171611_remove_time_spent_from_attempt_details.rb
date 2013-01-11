class RemoveTimeSpentFromAttemptDetails < ActiveRecord::Migration
  def up
    remove_column :attempt_details, :time_spent
  end

  def down
    add_column :attempt_details, :time_spent, :integer
  end
end
