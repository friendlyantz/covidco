class Question < ApplicationRecord
  belongs_to :place
  belongs_to :user
  validates :place, uniqueness: { scope: :user }
  validates :question, length: {minimum: 5, maximum: 200}, presence: true

end
