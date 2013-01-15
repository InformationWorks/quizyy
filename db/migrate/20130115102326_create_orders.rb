class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :responseCode
      t.text :responseDescription
      t.integer :cart_id

      t.timestamps
    end
  end
end
