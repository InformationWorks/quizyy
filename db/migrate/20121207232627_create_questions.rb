class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.integer :sequence_no
      t.text :header
      t.text :instruction
      t.text :passage
      t.text :que_text
      t.text :sol_text
      t.integer :option_set_count
      t.text :que_image
      t.text :sol_image
      t.string :di_location
      t.text :quantity_a
      t.text :quantity_b
      t.references :type
      t.references :topic
      t.references :section

      t.timestamps
    end
    add_index :questions, :type_id
    add_index :questions, :topic_id
    add_index :questions, :section_id
  end
end
