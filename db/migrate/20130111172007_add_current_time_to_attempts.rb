class AddCurrentTimeToAttempts < ActiveRecord::Migration
  def change
    add_column :attempts, :current_time, :integer
  end
end
