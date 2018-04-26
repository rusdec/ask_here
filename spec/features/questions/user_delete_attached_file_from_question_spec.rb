require_relative '../features_helper'

feature 'User can delete attached file from question', %q{
  As authenticated user
  I can delete attached file
  so that no one will use this file
} do

  given(:user) { create(:user) }
  given(:files) do
    [{ name: 'restart.txt', path: "#{Rails.root}/tmp/restart.txt" },
     { name: 'LICENSE', path: "#{Rails.root}/LICENSE" }]
  end

  context 'Authenticated user' do
    context 'when author of question' do

      context 'and create new question' do
        given(:question_attributes) { attributes_for(:question) }
        scenario 'can delete attached file', js: true do
          sign_in(user)
          visit new_question_path

          fill_in 'Title', with: question_attributes[:title]
          fill_in 'Body', with: question_attributes[:body]
          attach_files({ context: '.attachements', files: files })

          remove_attached_files('.attachements')
          click_on 'Create Question'

          files.each do |file|
            expect(page).to have_no_content(file[:name])
          end
        end
      end

      context 'and edit created question' do
        given!(:question) { create(:question, user: user) }

        scenario 'can delete attached file', js: true do
          sign_in(user)
          visit question_path(question)

          click_on 'Edit'
          remove_attached_files_when_edit('.question_editable_attachements')
          click_on 'Save'

          files.each do |file|
            expect(page).to have_no_content(file[:name])
          end
        end
      end

    end

    context 'when not author of question' do
      given(:question) { create(:question, user: user) }

      scenario 'no see remove attach option' do
        sign_in(create(:user))
        visit question_path(question)

        expect(page).to have_no_content('Remove file')
      end
    end
  end

  context 'Anauthenticated user' do
    given(:question) { create(:question, user: user) }
    scenario 'no see remove attach option' do
      visit question_path(question)

      expect(page).to have_no_content('Remove file')
    end
  end
end
