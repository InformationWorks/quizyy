class CreateActivityLogs < ActiveRecord::Migration
  def change
    create_table :activity_logs do |t|
      t.integer :actor_id
      t.string :action
      t.text :activity

      t.timestamps
    end
  end
end
