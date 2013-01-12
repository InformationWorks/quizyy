class AddEndToVisits < ActiveRecord::Migration
  def change
    add_column :visits, :end, :integer
  end
end
