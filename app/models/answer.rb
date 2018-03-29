class Answer < ApplicationRecord
  belongs_to :question

  validates :body, { presence: true,
                     length: { minimum: 10,
                               maximum: 1000 } }
end
