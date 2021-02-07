class Vote < ApplicationRecord
  belongs_to :review
  belongs_to :user

  validates :review, uniqueness: { scope: :user }
end
