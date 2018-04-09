require 'rails_helper'

feature 'User create question', %q{
  As user
  I can create question
  so that I can get help
} do

  given(:question) { attributes_for(:question) }
  given(:user) { create(:user) }
  given(:params) do
    { title: question[:title],
      body: question[:body] }
  end

  scenario 'User create question with valid data' do
    sign_in(user)
    create_question(params)

    expect(page).to have_content('success')
  end

  scenario 'User can\'t create question with invalid data' do
    sign_in(user)
    params[:title] = nil
    create_question(params)

    expect(page).to have_content('Errors:')
  end

  scenario 'Unauthorized user can\'t create question' do
    visit new_question_path

    expect(page).to have_content('Log in')
  end
end