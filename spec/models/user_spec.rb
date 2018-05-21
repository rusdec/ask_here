require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }

  it do
    should validate_length_of(:password).
      is_at_least(5).is_at_most(20)
  end

  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:authorizations) }

  it { should delegate_method(:vote_for).to(:votes) }

  let(:user) { create(:user_with_questions) }
  let(:question) { user.questions.last }

  it 'be an author of own question' do
    expect(user).to be_author_of(question)
  end

  it 'not be an author of foreign question' do
    expect(user).to be_not_author_of(create(:question, user: create(:user)))
  end

  it 'user should not be an author of given question' do
    second_user_question = create(:user_with_questions).questions.last
    expect(user).to_not be_author_of(second_user_question)
  end

  describe '#create_authorization' do
    let(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '12345') }

    it 'creates authorization for user' do
      expect {
        user.create_authorization(auth)
      }.to change(user.authorizations, :count).by(1)
    end

    it 'creates authorization with provider' do
      authorization = user.create_authorization(auth)

      expect(authorization.provider).to eq(auth.provider)
    end

    it 'creates authorization with uid' do
      authorization = user.create_authorization(auth)

      expect(authorization.uid).to eq(auth.uid)
    end
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:params) do
      { provider: 'github', uid: '12345' }
    end
    let(:auth) { OmniAuth::AuthHash.new(params) }

    context 'when user already has authorization' do
      it 'return user' do
        user.authorizations.create(params)
        expect(User.find_for_oauth(auth)).to eq(user)
      end
    end

    context 'when user has not authorization' do
      let(:auth) do
        OmniAuth::AuthHash.new(params.merge(info: { email: user.email }))
      end
      context 'and user exist' do
        it 'does not create new user' do
          expect { User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it 'creates authorization for user' do
          expect {
            User.find_for_oauth(auth)
          }.to change(user.authorizations, :count).by(1)
        end

        it 'creates authorization with provider' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq(auth.provider)
        end

        it 'creates authorization with uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.uid).to eq(auth.uid)
        end
      end

      context 'and user not exist' do
        let(:auth) do
          OmniAuth::AuthHash.new(params.merge(info: { email: 'bad@email.ru' }))
        end

        it 'creates new user' do
          expect {
            User.find_for_oauth(auth)
          }.to change(User, :count).by(1)
        end

        it 'return new user' do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end
        
        it 'fills user email' do
          user = User.find_for_oauth(auth)
          expect(user.email).to eq(auth.info.email)
        end

        it 'creates authorization for user' do
          user = User.find_for_oauth(auth)
          expect(user.authorizations).to_not be_empty
        end

        it 'creates authorization with provider' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq(auth.provider)
        end

        it 'creates authorization with uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.uid).to eq(auth.uid)
        end
      end
    end
  end
end
