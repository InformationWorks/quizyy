class CreateAttempts < ActiveRecord::Migration
  def change
    create_table :attempts do |t|
      t.references :user
      t.references :quiz
      t.boolean :completed, :default => false
      t.integer :current_question_id
      t.boolean :is_current

      t.timestamps
    end
    add_index :attempts, :user_id
    add_index :attempts, :quiz_id
    add_index :attempts, [:user_id, :quiz_id], :unique=>true
  end
end
