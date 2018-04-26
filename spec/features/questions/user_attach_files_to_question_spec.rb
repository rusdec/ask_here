require_relative '../features_helper'

feature 'User can attach files to question', %q{
  As author of question
  I can attach any files to question
  so that I can clarify the my problem
} do

  given(:user) { create(:user) }

  context 'Authenticated user' do
    before { sign_in(user) }

    given(:files) do
      [{ name: 'restart.txt', path: "#{Rails.root}/tmp/restart.txt" },
       { name: 'LICENSE', path: "#{Rails.root}/LICENSE" }]
    end

    context 'when create new question' do
      before { visit new_question_path }

      given(:question_attributes) { attributes_for(:question) }

      scenario 'can attach one or more files', js: true do
        create_question(question_attributes) do
          attach_files({ context: '.attachements', files: files })
        end

        files.each do |file|
          expect(page).to have_content(file[:name])
        end
      end
    end

    context 'when author of question' do
      before { visit question_path(create(:question, user: user)) }

      context 'and edit created question' do
        scenario 'can attach one or more files', js: true do
          click_on 'Edit'
          attach_files({ context: '.question_editable_attachements', files: files })
          click_on 'Save'
          
          files.each do |file|
            expect(page).to have_content(file[:name])
          end
        end
      end
    end

    context 'when not author of question' do
      before { visit question_path(create(:question, user: create(:user))) }

      scenario 'no see add file option' do
        within '.question' do
          expect(page).to have_no_content('Add file')
        end
      end
    end
  end

  context 'Unauthenticated user' do
    before { visit question_path(create(:question, user: user)) }

    scenario 'no see add file option' do
      expect(page).to have_no_content('Add file')
    end

  end
end
