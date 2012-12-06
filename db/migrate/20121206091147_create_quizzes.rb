class CreateQuizzes < ActiveRecord::Migration
  def change
    create_table :quizzes do |t|
      t.string :name
      t.boolean :random
      t.references :quiz_type
      t.references :category
      t.references :topic

      t.timestamps
    end
    add_index :quizzes, :quiz_type_id
    add_index :quizzes, :category_id
    add_index :quizzes, :topic_id
  end
end
