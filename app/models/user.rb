class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: %i[github]

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :password, length: { minimum: 5,
                                 maximum: 20 }

  delegate :vote_for, to: :votes

  def author_of?(entity)
    id == entity.user_id
  end

  def not_author_of?(entity)
    !author_of?(entity)
  end
end
