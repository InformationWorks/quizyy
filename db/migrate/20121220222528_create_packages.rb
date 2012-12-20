class CreatePackages < ActiveRecord::Migration
  def change
    create_table :packages do |t|
      t.string :name
      t.text :desc
      t.decimal :price

      t.timestamps
    end
  end
end
