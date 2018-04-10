require 'rails_helper'

feature 'User create answer', %q{
  As author of answer
  only I can delete my answers
  so that other users can't delete my answer
} do

  given(:user) { create(:user_with_question_and_answers) }
  given(:question) { user.questions.last }
  given(:answer_body) { user.answers.last.body }

  given(:second_user) { create(:user) }
  given(:second_user_answers) { create(:answer, user: second_user, question: question) }

  scenario 'User delete his answer' do
    sign_in(user)
    visit question_path(question)

    expect(page).to have_content(answer_body)

    click_on "Delete"

    expect(page).to have_content 'Answer delete success'
    expect(page).to have_no_content answer_body
  end

  scenario 'User can\'t delete answer of other user' do
    second_user_answers
    sign_in(user)

    visit question_path(question)
    within "tr:last-child" do
      expect(page).to have_no_content "Delete"
    end
  end

  scenario 'Non authorized user can\'t delete answer' do
    visit question_path(question)

    expect(page).to have_no_content('Delete')
  end
end
