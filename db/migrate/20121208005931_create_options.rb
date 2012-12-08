class CreateOptions < ActiveRecord::Migration
  def change
    create_table :options do |t|
      t.text :content
      t.boolean :correct
      t.references :question

      t.timestamps
    end
    add_index :options, :question_id
  end
end
