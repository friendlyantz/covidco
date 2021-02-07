class Place < ApplicationRecord
  has_many :reviews
  has_many :bookmarks
  has_many :users, through: :bookmarks
  has_many_attached :photos
  belongs_to :location, optional: true

  after_validation :geocode, if: :will_save_change_to_address?

  geocoded_by :address

  acts_as_taggable_on :tags  # allows virtual column of tags

  # PG SEARCH
  include PgSearch::Model
    pg_search_scope :search_by_name_description_category,
      against: [ :name, :description, :category ],
      associated_against: {
           reviews: [ :tip ],
           tags: [ :name ]
         },
      using: {
        tsearch: { prefix: true,  # <-- now `sush ` will return something!
                   any_word: true }
      }

  # VALIDATIONS
  validates :name, presence: true

  # DO WE NEED ADDRESS IF WE HAVE GPS.
  validates :address, presence: true


end
