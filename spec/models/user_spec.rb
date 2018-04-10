require 'rails_helper'

RSpec.describe User, type: :model do
  context 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }

    it do
      should validate_length_of(:password).
        is_at_least(5).is_at_most(20)
    end
  end

  context 'relations' do
    it { should have_many(:questions) }
    it { should have_many(:questions).dependent(:destroy) }
    it { should have_many(:answers) }
    it { should have_many(:answers).dependent(:destroy) }
  end

  context 'open interface' do
    let(:user) { create(:user_with_questions) }
    let(:question) { user.questions.last }

    let(:second_user_question) do
      create(:user_with_questions).questions.last
    end

    it 'user should be an author of given question' do
      expect(user.author_of?(question)).to eq true
    end

    it 'user should not be an author of given question' do
      expect(user.author_of?(second_user_question)).to eq false
    end
  end
end
