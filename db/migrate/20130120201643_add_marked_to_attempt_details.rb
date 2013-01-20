class AddMarkedToAttemptDetails < ActiveRecord::Migration
  def change
    add_column :attempt_details, :marked, :boolean
  end
end
