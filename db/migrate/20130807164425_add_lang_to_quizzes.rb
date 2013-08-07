class AddLangToQuizzes < ActiveRecord::Migration
  def change
    add_column :quizzes, :lang, :string
  end
end
