class CreateOffers < ActiveRecord::Migration
  def change
    create_table :offers do |t|
      t.references :offer_code
      t.string :title
      t.text :desc
      t.datetime :start
      t.datetime :stop
      t.boolean :global, :null => false, :default => true
      t.boolean :active, :null => false, :default => false
      t.integer :credits, :null => false, :default => 0

      t.timestamps
    end
    add_index :offers, :offer_code_id
  end
end
