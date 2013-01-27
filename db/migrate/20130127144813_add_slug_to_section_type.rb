class AddSlugToSectionType < ActiveRecord::Migration
  def change
    add_column :section_types, :slug, :string
    add_index :section_types, :slug
  end
end
