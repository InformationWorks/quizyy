class AddSlugToPackages < ActiveRecord::Migration
  def change
    add_column :packages, :slug, :string
    add_index :packages, :slug
  end
end
