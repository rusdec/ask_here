class Answer < ApplicationRecord
  include Attachable
  include Votable
  include Userable

  belongs_to :question

  default_scope { order(best: :DESC).order(:id) }
  scope :best_answers, -> { where(best: true) }
  scope :persisted_answers, -> { where.not(id: nil) }

  validates :body, { presence: true,
                     length: { minimum: 10,
                               maximum: 1000 } }

  def not_best?
    !best?
  end

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
