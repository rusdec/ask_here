require_relative '../features_helper'

feature 'User vote for a question', %q{
  As authenticated user
  I can once vote for any question
  so that express one's attitude to the question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:vote) { create(:question_vote,
                         votable: question,
                         user: create(:user),
                         value: true) }

  given(:votable) do
    { resource_name: 'question',
      resource_name_plural: 'question',
      resource_uri: question_path(question),
      resource: question,
      user: user
    }
  end
  it_behaves_like 'votable'
end
