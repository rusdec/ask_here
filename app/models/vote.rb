class Vote < ApplicationRecord
  include Userable
  belongs_to :votable, polymorphic: true

  validates_uniqueness_of :votable_id, scope: [:votable_type, :user_id]

  scope :likes, -> { where(value: true) }
  scope :dislikes, -> { where(value: false) }

  def self.vote_for(votable)
    find_by(votable: votable)
  end
end
