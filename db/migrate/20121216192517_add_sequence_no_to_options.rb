class AddSequenceNoToOptions < ActiveRecord::Migration
  def change
    add_column :options, :sequence_no, :integer
  end
end
