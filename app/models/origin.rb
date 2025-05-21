class Origin < ApplicationRecord
  belongs_to :ltn
  has_many :journeys, dependent: :nullify

  validates :lat, presence: true
  validates :lng, presence: true
  validates :name, presence: true
end
