class CreateOfferCodes < ActiveRecord::Migration
  def change
    create_table :offer_codes do |t|
      t.string :code
      t.text :desc

      t.timestamps
    end
  end
end
