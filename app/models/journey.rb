class Journey < ApplicationRecord
  self.inheritance_column = nil # type is used by the R program asker
  enum :type,
       { frequently_routed: 'frequently_routed', infrequently_routed: 'infrequently_routed',
         test_routing: 'test_routing' }
  belongs_to :ltn
  belongs_to :point_of_interest, optional: true
  belongs_to :origin, optional: true

  has_many :journey_runs, dependent: :destroy

  before_save :trim_name

  validates :type, :origin_lat, :origin_lng, :dest_lat, :dest_lng, presence: true
  validates :point_of_interest_id, uniqueness: { scope: :origin_id }, allow_nil: true
  validates :name, length: { maximum: 250 }, allow_blank: true

  attr_accessor :route_straight_away

  CREATE_PARAMS = %w[origin_lat origin_lng dest_lat dest_lng name].freeze
  def self.create_from_csv(file, scheme)
    transaction do
      CSV.foreach(file, headers: true) do |row|
        scheme.journeys.create!(row.to_h.transform_keys({ 'optional name' => 'name' }).slice(*CREATE_PARAMS))
      end
    end
  end

  def self.enable_all!
    where(disabled: true).update_all(disabled: false, updated_at: Time.current)
  end

  def self.disable_all!
    where(disabled: false).update_all(disabled: true, updated_at: Time.current)
  end

  def enabled
    !disabled
  end

  def enabled=(enabled)
    self.disabled = !ActiveModel::Type::Boolean.new.cast(enabled)
  end

  def display_name
    "#{name || 'Journey'} [#{id}]"
  end

  def map_data
    {
      controller: 'location',
      location_lat_value: origin_lat,
      location_lng_value: origin_lng,
      location_name_value: origin&.name || 'Origin',
      location_dest_lat_value: dest_lat,
      location_dest_lng_value: dest_lng,
      location_dest_name_value: point_of_interest&.name || 'Destination',
      location_persisted_value: true,
    }
  end

  def route!(run)
    resp = mapbox_directions[0]

    return unless resp['code'] == 'Ok'

    route = resp['routes'][0]
    leg = route['legs'][0]

    journey_runs.create!(
      run:,
      distance: route['distance'],
      duration: route['duration_typical'],
      duration_in_traffic: route['duration'],
      overview_polyline: route['geometry']['coordinates'],
      congestion_numeric: leg['annotation']['congestion_numeric'],
      incidents: leg['incidents']&.map { |incid| incid['long_description'] }&.to_sentence
    )
  end

  private

  def mapbox_directions
    Mapbox::Directions.directions(
      mapbox_coordinates, 'driving-traffic', geometries: 'geojson',
                                             annotations: 'congestion_numeric', waypoints_per_route: true, overview: 'full'
    )
  end

  def mapbox_coordinates
    [{ longitude: origin_lng, latitude: origin_lat }, { longitude: dest_lng, latitude: dest_lat }]
  end

  def trim_name
    self.name = name.strip[0, 250] if name
  end
end
