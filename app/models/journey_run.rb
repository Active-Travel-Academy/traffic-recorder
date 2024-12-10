require 'csv'
class JourneyRun < ApplicationRecord
  belongs_to :journey
  belongs_to :run

  scope :without_overview_polyline, -> { select(column_names - %w[overview_polyline congestion_numeric]) }

  MAX_RUNS_COUNT = 5_000

  CsvOption = Struct.new(:attr, :header, :parser) do
    def csv_header
      (header || attr).to_s.humanize.titleize.gsub(/\bId\b/, 'ID')
    end

    def parse(value)
      parser.nil? ? String(value) : parser.call(value)
    end
  end

  def self.to_csv(from:, to:, ltn:, overview_polyline: false)
    throw(:invalid_input, "To: '#{to}' is not a date") unless to.is_a?(Date)
    throw(:invalid_input, "From: '#{from}' is not a date") unless from.is_a?(Date)
    throw(:invalid_input, "From: '#{from}' must be before To: '#{to}'") unless from < to

    journey_attrs = [
      CsvOption.new(:id, "Journey ID"),
      CsvOption.new(:name, :journey_name),
      CsvOption.new(:origin_lat),
      CsvOption.new(:origin_lng, :origin_long),
      CsvOption.new(:dest_lat),
      CsvOption.new(:dest_lng, :dest_long),
    ]
    attributes = [
      CsvOption.new(:run_id, "Run ID"),
      CsvOption.new(:duration),
      CsvOption.new(:duration_in_traffic),
      CsvOption.new(:incidents),
      CsvOption.new(:distance),
      CsvOption.new(:created_at),
    ]

    runs = all.joins(:journey, :run).includes(:journey, :run).where(journeys: {ltn: ltn}, runs: {created_at: [from..to]}).order(:run_id)

    throw(:invalid_input, "Can only ask for #{MAX_RUNS_COUNT} journey runs at a time.  The between '#{from}' and '#{to}' there are #{runs.count} journey runs.") if runs.count > MAX_RUNS_COUNT

    if overview_polyline
      attributes.push(
        CsvOption.new(:overview_polyline, :overview_polyline, JSON.method(:generate)),
        CsvOption.new(:congestion_numeric, :congestion_numeric, JSON.method(:generate)),
      )
    else
      runs.without_overview_polyline
    end

    CSV.generate(headers: true) do |csv|
      csv << [ "Scheme", "Mode", *journey_attrs.map(&:csv_header), *attributes.map(&:csv_header) ]

      runs.find_each(cursor: %i[run_id id], batch_size: 500) do |j_run|
        csv << [
          ltn.scheme_name,
          j_run.run.mode,
          *journey_attrs.map { |attr| attr.parse(j_run.journey.attributes[attr.attr.to_s]) },
          *attributes.map { |attr| attr.parse(j_run.attributes[attr.attr.to_s]) },
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
