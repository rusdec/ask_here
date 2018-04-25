require_relative '../features_helper'

feature 'User can delete attached file from question', %q{
  As authenticated user
  I can delete attached file
  so that no one will use this file
} do

  given(:question_attributes) { attributes_for(:question) }
  given(:file) do
    { name: 'restart.txt',
      path: "#{Rails.root}/tmp/restart.txt" }
  end

  context 'Authenticated user' do
    context 'when create new question' do
      scenario 'can delete attached file', js: true do
        sign_in(create(:user))
        visit new_question_path
        fill_in 'Title', with: question_attributes[:title]
        fill_in 'Body', with: question_attributes[:body]
        attach_file 'File', file[:path]
        click_on 'Delete file'
        click_on 'Create Question'

        expect(page).to have_no_content(file[:name])
      end
    end
  end
end
