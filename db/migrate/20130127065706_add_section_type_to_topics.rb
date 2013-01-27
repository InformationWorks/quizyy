class AddSectionTypeToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :section_type_id, :integer
    add_index :topics, :section_type_id
  end
end
