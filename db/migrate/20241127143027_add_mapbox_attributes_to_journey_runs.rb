class AddMapboxAttributesToJourneyRuns < ActiveRecord::Migration[7.1]
  def change
    add_column :journey_runs, :congestion_numeric, :jsonb
    add_column :journey_runs, :incidents, :text
    change_column :journey_runs, :created_at, :datetime, default: nil
  end
end
