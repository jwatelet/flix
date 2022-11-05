class User < ApplicationRecord
  has_many :reviews, dependent: :destroy
  has_many :favourites, dependent: :destroy
  has_many :favourite_movies, through: :favourites, source: :movie

  has_secure_password

  validates :name, presence: true
  validates :email, format: { with: /\S+@\S+/ }, uniqueness: { case_sensitive: false }
  validates :username, presence: true,
                       format: { with: /\A[A-Z0-9]+\z/i },
                       uniqueness: { case_sensitive: false }

  def gravatar_id
    Digest::MD5.hexdigest(email.downcase)
  end
end
