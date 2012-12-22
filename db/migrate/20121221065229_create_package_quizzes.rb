class CreatePackageQuizzes < ActiveRecord::Migration
  def change
    create_table :package_quizzes do |t|
      t.references :package
      t.references :quiz

      t.timestamps
    end
    add_index :package_quizzes, :package_id
    add_index :package_quizzes, :quiz_id
  end
end
