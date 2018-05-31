require_relative '../features_helper'

feature 'User can attach and deattach files to answer', %q{
  As author of answer
  I can attach and deattach any files to answer
  so that I can better answer the question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question_with_answers, user: user, answers_count: 1) }

  given(:files_attachable) do
    { resource: 'answer',
      resources: 'answers', 
      new_resource_uri: question_path(question),
      edit_resource_uri: question_path(question),
      bad_author_uri: question_path(
        create(:question_with_answers, user: create(:user))
      ),
      user: user
    }
  end
  it_behaves_like 'files attachable'
end
