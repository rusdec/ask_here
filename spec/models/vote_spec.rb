require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to(:votable) }
  it { should belong_to(:user) }

  describe '#uniqueness' do
    subject { build :vote }

    it { should validate_uniqueness_of(:votable_id).
           scoped_to(:votable_type, :user_id) }
  end

  it 'get vote for specific entity' do
    user = create(:user)
    question = create(:question, user: create(:user))
    vote = create(:question_vote, votable: question, user: user)
    create(:question_vote, votable: question, user: create(:user))

    expect(user.votes.vote_for(question)).to eq(vote)
  end
end
