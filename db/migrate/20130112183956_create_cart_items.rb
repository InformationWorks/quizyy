class CreateCartItems < ActiveRecord::Migration
  def change
    create_table :cart_items do |t|
      t.references :quiz
      t.references :pacakge
      t.references :cart

      t.timestamps
    end
    add_index :cart_items, :quiz_id
    add_index :cart_items, :pacakge_id
    add_index :cart_items, :cart_id
  end
end
