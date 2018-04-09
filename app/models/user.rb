class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :questions, foreign_key: :author_id, dependent: :destroy
  has_many :answers, foreign_key: :author_id, dependent: :destroy

  validates :password, length: { minimum: 5,
                                 maximum: 20 }

  validate :validate_email_format

  def question_author?(question)
    questions.find_by(id: question.id)
  end

  def answer_author?(answer)
    answers.find_by(id: answer.id)
  end

  private

  def validate_email_format
    errors.add(:email, 'Bad email format') unless email_format =~ email
  end

  def email_format
    /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  end
end
