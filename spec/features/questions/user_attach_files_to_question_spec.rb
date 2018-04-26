require_relative '../features_helper'

feature 'User can attach files to question', %q{
  As author of question
  I can attach any files to question
  so that I can clarify the my problem
} do

  given(:user) { create(:user) }
  given(:question_attributes) { attributes_for(:question) }
  given(:files) do
    [{ name: 'restart.txt', path: "#{Rails.root}/tmp/restart.txt" },
     { name: 'LICENSE', path: "#{Rails.root}/LICENSE" }]
  end

  context 'Authenticated user' do

    context 'when create new question' do
      before do
        sign_in(user)
        visit new_question_path
      end

      scenario 'can attach one or more files', js: true do
        fill_in 'Title', with: question_attributes[:title]
        fill_in 'Body', with: question_attributes[:body]
        attach_files({ context: '.attachements', files: files })
        click_on 'Create Question'

        files.each do |file|
          expect(page).to have_content(file[:name])
        end
      end
    end

    context 'when author of question' do
      before do
        sign_in(user)
        visit question_path(create(:question, user: user))
      end

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
      before do
        sign_in(create(:user))
        visit question_path(create(:question, user: user))
      end

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
