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
    before { sign_in(user) }

    context 'when create new question' do
      before { visit new_question_path }

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
      before { visit question_path(create(:question, user: user)) }

      context 'and edit created question' do
        scenario 'can attach one or more files', js: true do
          click_on 'Edit'
          attach_files_when_edit({ context: '.question_editable_attachements',
                                   files: files })
          click_on 'Save'
          
          files.each do |file|
            expect(page).to have_content(file[:name])
          end
        end
      end
    end

  end
end
