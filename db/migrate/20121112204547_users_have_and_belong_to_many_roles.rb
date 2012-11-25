class UsersHaveAndBelongToManyRoles < ActiveRecord::Migration
  def change
    create_table :role_users do |t|
      t.references :role
      t.references :user

      t.timestamps
    end
    add_index :role_users, :role_id
    add_index :role_users, :user_id
  end
end
