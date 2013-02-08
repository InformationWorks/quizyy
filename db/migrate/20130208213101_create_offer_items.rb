class CreateOfferItems < ActiveRecord::Migration
  def change
    create_table :offer_items do |t|
      t.references :offer
      t.references :quiz
      t.references :package

      t.timestamps
    end
    add_index :offer_items, :offer_id
    add_index :offer_items, :quiz_id
    add_index :offer_items, :package_id
  end
end
