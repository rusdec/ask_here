class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user

  validates :body, { presence: true,
                     length: { minimum: 10,
                               maximum: 1000 } }

  validates :title, { presence: true,
                      length: { minimum: 10,
                                maximum: 30 } }

  def best_answers
    answers.where(best: true)
  end

  def created_answers
    answers.where.not(id: nil)
  end

  def uncheck_best_answers
    best_answers.each(&:not_best!)
  end
end
