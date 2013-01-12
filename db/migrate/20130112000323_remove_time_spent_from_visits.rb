class RemoveTimeSpentFromVisits < ActiveRecord::Migration
  def up
    remove_column :visits, :time_spent
  end

  def down
    add_column :visits, :time_spent, :integer
  end
end
