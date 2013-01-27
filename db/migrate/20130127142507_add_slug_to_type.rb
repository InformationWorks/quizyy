class AddSlugToType < ActiveRecord::Migration
  def change
    add_column :types, :slug, :string
    add_index :types, :slug
  end
end
