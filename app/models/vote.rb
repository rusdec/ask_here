class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  scope :vote_for, ->(question) { find_by(votable: question) }

  validates_uniqueness_of :votable_id, scope: [:votable_type, :user_id]
end
