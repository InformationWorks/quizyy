class AddStartToVisits < ActiveRecord::Migration
  def change
    add_column :visits, :start, :integer
  end
end
