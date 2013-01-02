class AddCurrentSectionIdToAttempts < ActiveRecord::Migration
  def change
    add_column :attempts, :current_section_id, :integer
  end
end
