class RmVacuumAndAnalyzeLargeTables < ActiveRecord::Migration[7.1]
  def change
    execute "ALTER TABLE ONLY public.journey_runs ALTER COLUMN journey_id SET STATISTICS 500;"
    execute "ALTER TABLE ONLY public.journey_runs ALTER COLUMN run_id SET STATISTICS 200;"
  end
end
