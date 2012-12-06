class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.string :name
      t.integer :sequence_no
      t.references :quiz
      t.references :section_type

      t.timestamps
    end
    add_index :sections, :quiz_id
    add_index :sections, :section_type_id
  end
end
