class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates_uniqueness_of :votable_id, scope: [:votable_type, :user_id]

  scope :likes_for, ->(votable) { where(votable: votable).where(value: true) }
  scope :dislikes_for, ->(votable) { where(votable: votable).where(value: false) }

  def self.vote_for(votable)
    find_by(votable: votable)
  end
end
