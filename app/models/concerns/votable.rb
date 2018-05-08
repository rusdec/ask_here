module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy

    delegate :likes, to: :votes
    delegate :dislikes, to: :votes
    delegate :rate, to: :votes
    delegate :rating, to: :votes
  end
end
