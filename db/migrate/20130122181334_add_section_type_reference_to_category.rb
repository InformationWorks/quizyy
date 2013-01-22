class AddSectionTypeReferenceToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :section_type_id, :integer
    add_index :categories, :section_type_id
  end
end
