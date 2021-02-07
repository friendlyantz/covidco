class Review < ApplicationRecord
  belongs_to :place
  belongs_to :user
  has_many :votes
  has_many_attached :photos
  # validates :content, presence: true

  # TIP 5-100 characters
  validates :tip, length: {minimum: 5, maximum: 100}, allow_blank: true

  # UNIQUE REVIEW FOR A PLACE BY THE USER
  validates :place, uniqueness: { scope: :user }

  # COVID RATING by USER: 1 - 10 stars
  validates :covid_rating, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }#, presence: true

  # QnA / TIPS questionary: 0 - NEGATIVE answer, 1 - Positive answer, 2 - Unsure
  # @@options = [ 2, 4 ]
  OPTIONS_YES_NO = [ [ "No", 0], ["Yes", 5] ]
  OPTIONS = [ ["Terrible", 1],  ["Poor", 2], ["Average", 3], ["Good", 4] , ["Excellent", 5] ]
  OPTIONS_3_STARS = [ ["Not sure", 0], ["Bad", 1], ["Average", 3], ["Great", 5] ]
  # hand_sanitizer: [ :not_sure, :bad, :average, :good ]
  # enum q2_measures: [:poor_measures, :good_measure, :unsure_about_measures]
  # enum q3_comforatble_stay: [:uncomforatble_stay, :comforatble_stay, :unsure_about_comfortability]
  # enum q4_responsible_guests: [:irresponsible_guests, :responsible_guests, :unsure_about_guests]
  # enum q5_floors: [:unmarked_floors, :marked_floors, :unsure_about_floors]
end
