class CreateOfferUsers < ActiveRecord::Migration
  def change
    create_table :offer_users do |t|
      t.references :offer
      t.references :user

      t.timestamps
    end
    add_index :offer_users, :offer_id
    add_index :offer_users, :user_id
  end
end
