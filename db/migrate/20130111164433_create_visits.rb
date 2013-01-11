class CreateVisits < ActiveRecord::Migration
  def change
    create_table :visits do |t|
      t.references :attempt
      t.references :question
      t.integer :time_spent

      t.timestamps
    end
  end
end
