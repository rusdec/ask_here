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

  let(:user) { create(:user_with_questions) }
  let(:question) { user.questions.last }

  it 'user should be an author of given question' do
    expect(user).to be_author_of(question)
  end

  it 'user should not be an author of given question' do
    second_user_question = create(:user_with_questions).questions.last
    expect(user).to_not be_author_of(second_user_question)
  end
end
