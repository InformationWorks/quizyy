class IndexAttemptsReport < ActiveRecord::Migration
  def up
    execute "CREATE INDEX attempts_report ON attempts USING GIN(report)"
  end

  def down
    execute "DROP INDEX attempts_report"
  end
end
