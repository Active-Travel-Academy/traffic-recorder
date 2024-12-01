class SwitchRunModeEnum < ActiveRecord::Migration[7.1]
  def change
    create_enum "run_mode_new", ["driving", "test_driving"]
    execute <<~SQL
      ALTER TABLE runs
        ALTER COLUMN mode DROP DEFAULT,
        ALTER COLUMN mode
          TYPE run_mode_new
          USING mode::text::run_mode_new,
        ALTER COLUMN mode SET DEFAULT 'driving';
    SQL
    drop_enum :run_mode
    rename_enum :run_mode_new, to: :run_mode
  end
end
