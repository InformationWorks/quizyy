class AddDisplayTextToSections < ActiveRecord::Migration
  def change
    add_column :sections, :display_text, :text
  end
end
