class CreateScaledScores < ActiveRecord::Migration
  def change
    create_table :scaled_scores do |t|
      t.integer :value
      t.integer :verbal_score
      t.integer :quant_score

      t.timestamps
    end
  end
end
