# frozen_string_literal: true

class Ltn < ApplicationRecord
  DEFAULT_LAT = 51.505
  DEFAULT_LNG = -0.09

  belongs_to :user
  has_many :journeys
  has_many :runs
  has_many :point_of_interests
  has_many :origins
  validates :scheme_name, presence: true, length: {minimum: 3, maximum: 45},
                   uniqueness: {scope: :user}
  validates :default_lat, presence: true
  validates :default_lng, presence: true

  def create_poi_origin_journeys!
    transaction do
      point_of_interests.each do |poi|
        origins.each do |origin|
          journeys.find_or_create_by(
            point_of_interest: poi,
            origin:
          ) do |journey|
            journey.type = :frequently_routed
            journey.origin_lat = origin.lat
            journey.origin_lng = origin.lng
            journey.dest_lat = poi.lat
            journey.dest_lng = poi.lng
            journey.name = "#{origin.name} to #{poi.name}"
          end
        end
      end
    end
  end
end
