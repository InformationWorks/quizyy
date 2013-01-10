class AddUserInnputToAttemptDetails < ActiveRecord::Migration
  def change
    add_column :attempt_details, :user_input, :string
  end
end
