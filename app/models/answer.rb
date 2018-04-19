class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  default_scope { order(best: :DESC).order(:id) }
  scope :best_answers, -> { where(best: true) }
  scope :created_answers, -> { where.not(id: nil) }

  validates :body, { presence: true,
                     length: { minimum: 10,
                               maximum: 1000 } }

  def not_best!
    update(best: false)
  end

  def best!
    ApplicationRecord.transaction do
      question.best_answers.update_all(best: false)
      update!(best: true)
    end
  end
end
