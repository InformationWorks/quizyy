class CreateAttemptDetails < ActiveRecord::Migration
  def change
    create_table :attempt_details do |t|
      t.references :attempt
      t.references :question
      t.references :option
      t.integer :time_spent

      t.timestamps
    end
  end
end
