class CreateQuizUsers < ActiveRecord::Migration
  def change
    create_table :quiz_users do |t|
      t.references :quiz
      t.references :user

      t.timestamps
    end
    add_index :quiz_users, :quiz_id
    add_index :quiz_users, :user_id
  end
end
