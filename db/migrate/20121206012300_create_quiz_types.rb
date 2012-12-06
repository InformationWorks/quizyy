class CreateQuizTypes < ActiveRecord::Migration
  def change
    create_table :quiz_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
