class CreateCartItems < ActiveRecord::Migration
  def change
    create_table :cart_items do |t|
      t.references :quiz
      t.references :package
      t.references :cart

      t.timestamps
    end
    add_index :cart_items, :quiz_id
    add_index :cart_items, :package_id
    add_index :cart_items, :cart_id
  end
end
