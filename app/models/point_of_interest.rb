class PointOfInterest < ApplicationRecord
  belongs_to :ltn
  has_many :journeys, dependent: :nullify

  validates :lat, presence: true
  validates :lng, presence: true
  validates :name, presence: true

  def self.locate(poi:, lat:, lng:, limit: 25)
    return [] if poi.blank? || lat.blank? || lng.blank?

    Mapbox.request(
      :get, "/search/searchbox/v1/category/#{poi}?language=en&limit=#{limit}&proximity=#{lng}%2C#{lat}", nil
    )[0]
  end

  # only use to generate CATEGORYS manually
  def self.categories
    Mapbox.request(
      :get, '/search/searchbox/v1/list/category', nil
    )[0]['listItems'].map { |li| li['canonical_id'] }
  end

  CATEGORIES = {
    grocery: 'Greengrocer',
    supermarket: 'Supermarket',
    elementary_school: 'Primary School',
    post_office: 'Post Office',
    veterinarian: 'Vet',
    shopping_mall: 'Shopping Centre',
    hospital: 'Hospital',
    recycling_center: 'Recycling Centre',
    bus_stop: 'Bus Stop',
    railway_station: 'Railway Station',
    pharmacy: 'Pharmacy',
    park: 'Park',
    fitness_center: 'Leisure Centre',
    restaurant: 'Restaurant',
    library: 'Library',
    dentist: 'Dental Surgery',
    light_rail_station: 'Tram Stop'
  }.freeze

  validates :category, inclusion: { in: CATEGORIES.keys.map(&:to_s) }, allow_blank: true
end
