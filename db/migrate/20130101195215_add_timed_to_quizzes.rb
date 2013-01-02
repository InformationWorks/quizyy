class AddTimedToQuizzes < ActiveRecord::Migration
  def change
    add_column :quizzes, :timed, :boolean
  end
end
