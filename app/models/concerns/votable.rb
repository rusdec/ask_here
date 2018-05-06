module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy

    accepts_nested_attributes_for :votes, allow_destroy: true,
                                          reject_if: :all_blank
    delegate :likes, to: :votes
    delegate :dislikes, to: :votes
    delegate :rate, to: :votes
    delegate :rating, to: :votes
  end
end
