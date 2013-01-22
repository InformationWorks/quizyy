class AddReportToAttempts < ActiveRecord::Migration
  def change
    add_column :attempts, :report, :hstore
  end
end
