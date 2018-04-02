class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :password, length: { minimum: 5,
                                 maximum: 20 }

  validate :validate_email_format

  private

  def validate_email_format
    errors.add(:email, 'Bad email format') unless email_format =~ email
  end

  def email_format
    /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  end
end
