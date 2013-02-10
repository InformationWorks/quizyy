class CreateOfferUsers < ActiveRecord::Migration
  def change
    create_table :offer_users do |t|
      t.references :offer
      t.string :email

      t.timestamps
    end
    add_index :offer_users, :offer_id
  end
end
