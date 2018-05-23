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

  describe '.create_user' do
    let(:auth) do
      OmniAuth::AuthHash.new(uid: '12345',
                             provider: 'github',
                             info: { email: 'example@mail.com' })
    end

    context 'when auth.with_request_email is given' do
      before { auth.with_request_email = true }

      context 'when email valid' do
        it 'creates user is unconfirmed' do
          expect(User.find_for_oauth(auth)).to_not be_confirmed
        end
      end
    end

    context 'when auth.with_request_email isn\'t given' do
      it 'creates user is confirmed' do
        expect(User.find_for_oauth(auth)).to be_confirmed
      end
    end

    it 'creates new user' do
      expect {
        User.find_for_oauth(auth)
      }.to change(User, :count).by(1)
    end

    it 'fills user email' do
      expect(User.find_for_oauth(auth).email).to eq(auth.info.email)
    end

    it 'return new user' do
      expect(User.find_for_oauth(auth)).to be_a(User)
    end
  end

  describe '#create_authorization' do
    let(:user) { create(:user) }
    let(:auth) do
      OmniAuth::AuthHash.new(provider: 'any_provider', uid: 'any_uid')
    end

    it 'creates authorization for user' do
      expect {
        user.create_authorization(auth)
      }.to change(user.authorizations, :count).by(1)
    end

    it 'creates authorization with provider' do
      user.create_authorization(auth)

      expect(user.authorizations.first.provider).to eq(auth.provider)
    end

    it 'creates authorization with uid' do
      user.create_authorization(auth)

      expect(user.authorizations.first.uid).to eq(auth.uid)
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
      end

      context 'and user not exist' do
        let(:auth) do
          OmniAuth::AuthHash.new(params.merge(info: { email: 'test@example.com' }))
        end

        context 'and email given via special form' do
          before { auth.with_request_email = true }

          it 'send confirmation email' do
            expect(User.find_for_oauth(auth)).to be_confirmation_sent_at
          end
        end
        
        it 'creates authorization for user' do
          expect(User.find_for_oauth(auth).authorizations).to_not be_empty
        end

        it 'return new user' do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end
      end
    end
  end
end
