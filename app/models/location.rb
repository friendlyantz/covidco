class Location < ApplicationRecord
  has_many :users
  has_many :places
  has_one_attached :photo

  validates :city, presence: true

  # validates :latitude, presence: true
  # validates :longitude, presence: true

end
