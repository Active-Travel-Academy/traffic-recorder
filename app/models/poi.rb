class Poi < ApplicationRecord
  def self.locate(poi:, lat:, lng:, limit: 10)
    Mapbox.request(
      :get, "/search/searchbox/v1/category/#{poi}?language=en&limit=#{limit}&proximity=#{lng}%2C#{lat}", nil
    )
  end
end
