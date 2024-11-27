class MoveRunsToTimestamps < ActiveRecord::Migration[7.1]
  def change
    change_column :runs, :time, :datetime, default: nil
    change_column :runs, :finished_at, :datetime, default: nil
    rename_column :runs, :time, :created_at
  end
end
