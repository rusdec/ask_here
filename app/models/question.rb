class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :attachements, as: :attachable,
                          inverse_of: :attachable,
                          dependent: :destroy
  belongs_to :user

  validates :body, { presence: true,
                     length: { minimum: 10,
                               maximum: 1000 } }

  validates :title, { presence: true,
                      length: { minimum: 10,
                                maximum: 30 } }

  accepts_nested_attributes_for :attachements, allow_destroy: true,
                                               reject_if: :rejected_attachement?

  def best_answers
    answers.best_answers
  end

  def created_answers
    answers.created_answers
  end

  private

  def rejected_attachement?(attachement)
    attachement[:file].blank?
  end
end
