class AddMissingFieldsToQuizzes < ActiveRecord::Migration
  def change
    # Add publisher fields
    add_column :quizzes, :published, :boolean, :default => false
    add_column :quizzes, :publisher_id, :integer
    add_column :quizzes, :published_at, :datetime
    # Add approver fields
    add_column :quizzes, :approved, :boolean, :default => false
    add_column :quizzes, :approver_id, :integer
    add_column :quizzes, :approved_at, :datetime
    # Add indexes
    add_index :quizzes, :publisher_id
    add_index :quizzes, :approver_id
  end
end
