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
  has_many :authorizations

  validates :password, length: { minimum: 5,
                                 maximum: 20 }

  delegate :vote_for, to: :votes

  def author_of?(entity)
    id == entity.user_id
  end

  def not_author_of?(entity)
    !author_of?(entity)
  end

  def self.find_for_oauth(auth)
    # when User exist and has given Authorization
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid).first
    return authorization.user if authorization

    user = find_by(email: auth.info.email)

    # when User not exist
    unless user
      password = Devise.friendly_token(10)
      user = User.create(email: auth.info.email,
                         password: password,
                         password_confirmation: password)
    end

    # when user exist and hasn't given Authorization
    user.create_authorization(auth)

    user
  end

  def create_authorization(auth)
    authorizations.create(provider: auth.provider, uid: auth.uid)
  end
end
