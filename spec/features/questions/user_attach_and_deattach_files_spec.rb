require_relative '../features_helper'

feature 'User can attach and deattach files to question', %q{
  As author of question
  I can attach any files to question
  so that I can clarify the my problem
} do

  given(:user) { create(:user) }

   given(:files_attachable) do
    { resource_name: 'question',
      resource_name_plural: 'question',
      new_resource_uri: new_question_path,
      edit_resource_uri: question_path(create(:question, user: user)),
      bad_author_uri: question_path(
        create(:question_with_answers, user: create(:user))
      ),
      user: user
    }
  end
  it_behaves_like 'files attachable'
end
