class AddTimeToSection < ActiveRecord::Migration
  def change
    add_column :sections, :time, :integer, :null => false, :default => 0
  end
end
