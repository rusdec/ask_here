require_relative '../features_helper'

feature 'User create question', %q{
  As user
  I can create question
  so that I can get help
} do

  given(:question) { attributes_for(:question) }
  given(:user) { create(:user) }

  context 'Authenticated user' do
    before { sign_in(user) }
    let(:params) do
      { title: question[:title], body: question[:body] }
    end

    scenario 'see ask question link' do
      visit questions_path
      expect(page).to have_content('Ask question')
    end

    scenario 'can create question with valid data' do
      create_question(params)
      question = user.questions.order(:id).last

      expect(page).to have_content(question.title)
      expect(page).to have_content(question.body)
    end

    scenario 'can\'t create question with invalid data' do
      params[:title] = nil
      create_question(params)

      expect(page).to have_content('Title can\'t be blank')
    end
  end

  context 'Unauthenticated user' do
    scenario 'no see ask question link' do
      visit questions_path
      expect(page).to_not have_content('Ask question')
    end
  end

  context 'multiple sessions' do
    scenario 'question appears on another user\'s page', js: true do
      Capybara.using_session('guest') do
        visit questions_path
      end
      Capybara.using_session('author') do
        sign_in(user)
        create_question(title: question[:title], body: question[:body])
      end
      Capybara.using_session('guest') do
        expect(page).to have_content(question[:title])
      end
    end
  end
end
