class ChangeDataTypeForAttemptScore < ActiveRecord::Migration
  def up
    change_table :attempts do |t|
      t.change :score, :float
    end
  end

  def down
    change_table :attempts do |t|
      t.change :score, :integer
    end
  end
end
