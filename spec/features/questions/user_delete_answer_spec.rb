require_relative '../features_helper'

feature 'User delete answer', %q{
  As author of answer
  only I can delete my answers
  so that other users can't delete my answer
} do

  given(:user) { create(:user_with_question_and_answers) }
  given(:question) { user.questions.last }
  given(:answer) { user.answers.last }
  given(:answer_body) { answer.body }

  given(:second_user) { create(:user) }

  scenario 'Authenticated user can delete his answer', js: true do
    sign_in(user)
    visit question_path(question)

    expect(page).to have_content(answer_body)

    click_delete_answer_link(answer)

    expect(page).to have_content 'Answer delete success'
    expect(page).to have_no_content answer_body
  end

  scenario 'Authenticated user no see delete link for not him answer' do
    sign_in(second_user)
    visit question_path(question)
    
    expect(page).to have_no_selector(answer_delete_link(answer))
  end

  scenario 'Unauthenticated user no see delete answer links' do
    visit question_path(question)
    
    question.answers.each do |answer|
      expect(page).to have_no_selector(answer_delete_link(answer))
    end
  end
end
