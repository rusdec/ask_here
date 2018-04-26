require_relative '../features_helper'

feature 'User can delete attached file from question', %q{
  As authenticated user
  I can delete attached file
  so that no one will use this file
} do

  given(:user) { create(:user) }

  context 'Authenticated user' do
    context 'when author of question' do

      context 'and create new question' do
        given(:question_attributes) { attributes_for(:question) }
        given(:file) do
          { name: 'restart.txt',
            path: "#{Rails.root}/tmp/restart.txt" }
        end
        scenario 'can delete attached file', js: true do
          sign_in(user)
          visit new_question_path

          fill_in 'Title', with: question_attributes[:title]
          fill_in 'Body', with: question_attributes[:body]
          attach_file 'File', file[:path]

          click_on 'Remove file'
          click_on 'Create Question'

          expect(page).to have_no_content(file[:name])
        end
      end

      context 'and edit created question' do
        given!(:question) { create(:question, user: user) }
        given!(:attachement) { create(:attachement, attachable: question) }
        given!(:file_name) { attachement.file.file.filename }

        scenario 'can delete attached file', js: true do
          sign_in(user)
          visit question_path(question)

          expect(page).to have_content(file_name)

          click_on "Edit"
          check "Remove file"
          click_on "Save"

          expect(page).to have_no_content(file_name)
        end
      end

    end
  end
end
