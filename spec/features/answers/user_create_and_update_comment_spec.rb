require_relative '../features_helper'

feature 'User create and update comment', %q{
  As authonticated user
  I can create and update comment of answer
  so that i can supplement or clarify anything from the inquirer
} do

  given(:question) { create(:question_with_answers, answers_count: 1,
                            user: create(:user)) }

  let!(:commentable) do
    { resource_name: 'answer',
      resource_name_plural: 'answers',
      resource_uri: question_path(question),
      resource_container: answer_container(question.answers.last),
      resource: question.answers.last
    }
  end
  it_behaves_like 'commentable'
end
