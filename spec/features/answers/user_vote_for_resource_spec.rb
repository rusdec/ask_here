require_relative '../features_helper'

feature 'User vote for an answer', %q{
  As authenticated user
  I can once vote for any answer
  so that express one's attitude to the answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, question: question, user: user) }
  given!(:vote) { create(:answer_vote, votable: answer, user: user, value: true) }

  given(:votable) do
    { resource_name: 'answer',
      resource_name_plural: 'answers',
      resource_uri: question_path(question),
      resource: answer,
      user: user
    }
  end
  it_behaves_like 'votable'
end
