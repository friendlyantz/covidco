class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable
  before_create :default_location
  def default_location
    self.location ||= Location.first
    self.first_name ||= "First Name"
    self.last_name ||= "git"
  end

  belongs_to :location, optional: true
  has_many :reviews # ??????????
  has_many :votes

  # BOOKMARKS FOR PLACES
  has_many :bookmarks
  has_many :places, through: :bookmarks

  validates :email, presence: true, uniqueness: true

  enum covid_status: [:not_tested, :testing, :tested_negative, :tested_positive ]

  # ACTIVE STORAGE 
  # has_one_attached :photo
end
