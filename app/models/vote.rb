class Vote < ApplicationRecord
  include Userable
  belongs_to :votable, polymorphic: true

  validates :user_id, uniqueness: { scope: [:votable_id, :votable_type] }

  scope :likes, -> { where(value: true) }
  scope :dislikes, -> { where(value: false) }

  def self.vote_for(votable)
    find_by(votable: votable)
  end

  def self.rate
    likes.count - dislikes.count
  end

  def self.rating
    { likes: likes.count, dislikes: dislikes.count, rate: rate }
  end
end
