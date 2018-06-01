require_relative '../features_helper'

feature 'User create and update comment', %q{
  As authonticated user
  I can create and update comment of question
  so that i can supplement or clarify anything from the inquirer
} do

  let(:question) { create(:question, user: create(:user)) }
  let!(:commentable) do
    { resource_name: 'question',
      resource_name_plural: 'question',
      resource_uri: question_path(question),
      resource_container: '.question',
      resource: question
    }
  end
  it_behaves_like 'commentable'
end
