class Answer < ApplicationRecord
  validates :body, { presence: true,
                     length: { minimum: 10,
                               maximum: 1000 } }
  validates :question_id, { presence: true,
                            numericality: { only_integer: true } }

  belongs_to :question
end
