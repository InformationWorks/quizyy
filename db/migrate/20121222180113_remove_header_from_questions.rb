class RemoveHeaderFromQuestions < ActiveRecord::Migration
  def up
    remove_column :questions, :header
  end

  def down
    add_column :questions, :header, :text
  end
end
