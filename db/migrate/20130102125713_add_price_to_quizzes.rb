class AddPriceToQuizzes < ActiveRecord::Migration
  def change
    add_column :quizzes, :price, :decimal, :precision => 10, :scale => 2, :default => 0.0
  end
end
