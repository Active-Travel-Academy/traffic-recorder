require 'csv'
class JourneyRun < ApplicationRecord
  belongs_to :journey
  belongs_to :run

  scope :without_overview_polyline, -> { select(column_names - %w[overview_polyline congestion_numeric]) }

  MAX_RUNS_COUNT = 5_000

  def self.to_csv(from:, to:, ltn:, overview_polyline: false)
    throw(:invalid_input, "To: '#{to}' is not a date") unless to.is_a?(Date)
    throw(:invalid_input, "From: '#{from}' is not a date") unless from.is_a?(Date)
    throw(:invalid_input, "From: '#{from}' must be before To: '#{to}'") unless from < to

    journey_attrs = %w{origin_lat origin_lng dest_lat dest_lng}
    attributes = %w{run_id duration duration_in_traffic incidents distance created_at}

    runs = all.joins(:journey, :run).includes(:journey, :run).where(journeys: {ltn: ltn}, runs: {created_at: [from..to]}).order(:run_id)

    throw(:invalid_input, "Can only ask for #{MAX_RUNS_COUNT} journey runs at a time.  The between '#{from}' and '#{to}' there are #{runs.count} journey runs.") if runs.count > MAX_RUNS_COUNT

    if overview_polyline
      attributes.push("overview_polyline", "congestion_numeric")
    else
      runs.without_overview_polyline
    end

    CSV.generate(headers: true) do |csv|
      csv << [ "scheme", "mode", "journey_id",  *journey_attrs, *attributes ]

      runs.find_each(cursor: %i[run_id id], batch_size: 500) do |j_run|
        csv << [
          ltn.scheme_name,
          j_run.run.mode,
          j_run.attributes["journey_id"],
          *journey_attrs.map { |attr| j_run.journey.attributes[attr] },
          *attributes.map { |attr| j_run.attributes[attr].to_json },
        ]
      end
    end
  end

  def map_data
    {
      line: overview_polyline
    }
  end
end
