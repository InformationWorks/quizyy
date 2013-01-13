class AddTargetToActivityLog < ActiveRecord::Migration
  def change
    add_column :activity_logs, :target_id, :integer
  end
end
