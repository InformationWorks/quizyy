class CreateTypes < ActiveRecord::Migration
  def change
    create_table :types do |t|
      t.references :category
      t.string :code
      t.string :name

      t.timestamps
    end
    add_index :types, :category_id
  end
end
