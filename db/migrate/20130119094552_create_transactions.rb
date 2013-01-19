class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string :action
      t.integer :responseCode
      t.string :responseDescription
      t.string :ipaddress
      t.references :order
      t.references :user

      t.timestamps
    end
    add_index :transactions, :order_id
    add_index :transactions, :user_id
  end
end
