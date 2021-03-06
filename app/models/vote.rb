class Vote < ApplicationRecord
  include Userable
  belongs_to :votable, polymorphic: true, touch: true

  validates :value, presence: true, acceptance: { accept: [-1, 1] }
  validates :user_id, uniqueness: { scope: [:votable_id, :votable_type] }

  class << self
    def vote_for(votable)
      find_by(votable: votable)
    end

    def likes
      where(value: 1).count
    end

    def dislikes
      where(value: -1).count
    end

    def rate
      sum(:value)
    end

    def rating
      { likes: likes, dislikes: dislikes, rate: rate }
    end

    def vote!(params)
      vote = vote_for(params[:votable])
      ApplicationRecord.transaction do
        vote.destroy! unless vote.nil?
        create!(params)
      end
    end
  end

  def like?
    value == 1
  end

  def dislike?
    value == -1
  end

end
