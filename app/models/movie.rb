class Movie < ApplicationRecord
  before_save :set_slug

  has_one_attached :main_image
  has_many :reviews, -> { order(created_at: :desc) }, dependent: :destroy
  has_many :favourites, dependent: :destroy
  has_many :fans, through: :favourites, source: :user
  has_many :critics, through: :reviews, source: :user
  has_many :characterizations, dependent: :destroy
  has_many :genres, through: :characterizations

  RATINGS = %w[G PG PG-13 R NC-17]

  validates :title, presence: true, uniqueness: true
  validates :released_on, :duration, presence: true
  validates :description, length: { minimum: 25 }
  validates :total_gross, numericality: { greater_than_or_equal_to: 0 }
  validate :acceptable_image

  validates :rating, inclusion: { in: RATINGS }

  scope :released, -> { where('released_on < ?', Time.zone.now).order('released_on desc') }
  scope :upcoming, -> { where('released_on > ?', Time.zone.now).order('released_on asc') }
  scope :recent, ->(max = 5) { released.limit(max) }
  scope :hits, -> { released.where('total_gross >= 300000000').order(total_gross: :desc) }
  scope :flops, -> { released.where('total_gross < 22500000').order(total_gross: :asc) }
  scope :grossed_less_than, ->(amount) { released.where('total_gross < ?', amount) }
  scope :grossed_greater_than, ->(amount) { released.where('total_gross > ?', amount) }

  def flop?
    total_gross.blank? || total_gross < 225_000_000
  end

  def average_stars_as_percent
    (average_stars / 5.0) * 100
  end

  def average_stars
    reviews.average(:stars) || 0.0
  end

  def self.flops
    where('total_gross < ?', 225_000_000).order(total_gross: :asc)
  end

  def self.recently_added
    order(created_at: :desc).limit(3)
  end

  def to_param
    slug
  end

  private

  def acceptable_image
    return unless main_image.attached?

    errors.add(:main_image, 'is too big') unless main_image.blob.byte_size <= 1.megabyte

    acceptable_types = ['image/jpeg', 'image/png']
    errors.add(:main_image, 'must be a JPEG or PNG') unless acceptable_types.include?(main_image.content_type)
  end

  def set_slug
    self.slug = title.parameterize
  end
end
