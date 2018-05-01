class Question < ApplicationRecord
  include Attachable

  has_many :answers, dependent: :destroy
  has_many :votes, as: :votable,
                   dependent: :destroy

  belongs_to :user

  validates :body, { presence: true,
                     length: { minimum: 10,
                               maximum: 1000 } }

  validates :title, { presence: true,
                      length: { minimum: 10,
                                maximum: 30 } }

  delegate :likes, to: :votes
  delegate :dislikes, to: :votes

  def best_answers
    answers.best_answers
  end

  def persisted_answers
    answers.persisted_answers
  end

  def vote
  end
end
