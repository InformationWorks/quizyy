class AddDescToActivityLog < ActiveRecord::Migration
  def change
    add_column :activity_logs, :desc, :string
  end
end
