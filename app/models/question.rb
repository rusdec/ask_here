class Question < ApplicationRecord
  include Attachable
  include Votable
  include Userable

  has_many :answers, dependent: :destroy

  validates :body, { presence: true,
                     length: { minimum: 10,
                               maximum: 1000 } }

  validates :title, { presence: true,
                      length: { minimum: 10,
                                maximum: 30 } }

  def best_answers
    answers.best_answers
  end

  def persisted_answers
    answers.persisted_answers
  end
end
