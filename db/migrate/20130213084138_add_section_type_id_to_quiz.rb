class AddSectionTypeIdToQuiz < ActiveRecord::Migration
  def change
    add_column :quizzes, :section_type_id, :integer
    add_index :quizzes, :section_type_id
  end
end
