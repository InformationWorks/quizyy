class AddSlugToQuizType < ActiveRecord::Migration
  def change
    add_column :quiz_types, :slug, :string
    add_index :quiz_types, :slug
  end
end
