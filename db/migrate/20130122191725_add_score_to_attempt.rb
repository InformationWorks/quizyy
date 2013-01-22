class AddScoreToAttempt < ActiveRecord::Migration
  def change
    add_column :attempts, :score, :integer
  end
end
