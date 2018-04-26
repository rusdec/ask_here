require_relative '../features_helper'

feature 'User can delete attached files from answer', %q{
  As author of answer
  I can delete attached from answer
  so that no one will use this files
} do

  given(:user) { create(:user) }
  given(:question) { create(:question_with_answers, answers_count: 1, user: user) }

  context 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    given(:files) do
      [{ name: 'restart.txt', path: "#{Rails.root}/tmp/restart.txt" },
       { name: 'LICENSE', path: "#{Rails.root}/LICENSE" }]
    end

    context 'when create new answer' do
      given(:answer_attributes) { attributes_for(:answer) }

      scenario 'can delete attach one or more files', js: true do
        within '#new_answer' do
          fill_in 'Body', with: answer_attributes[:body]
          attach_files({ context: '.new_answer_attachements', files: files })
          
          remove_attached_files('.new_answer_attachements')
          click_on 'Create Answer'
        end
        
        files.each do |file|
          expect(page).to have_no_content(file[:name])
        end
      end
    end

    context 'when author of answer' do
      context 'and edit created answer' do
        scenario 'can attach one or more files', js: true do
          within '.answers' do
            #attach files
            click_on 'Edit'
            attach_files({ context: '.answer_editable_attachements', files: files })
            click_on 'Save'

            #remove attached files
            click_on 'Edit'
            remove_attached_files_when_edit('.answer_editable_attachements')
            click_on 'Save'
          end

          files.each do |file|
            expect(page).to have_no_content(file[:name])
          end
        end
      end
    end

    context 'when not author of answer' do
      before do
        visit question_path(create(:question_with_answers, user: create(:user)))
      end

      scenario 'no see remove attach option' do
        within '.answers' do
          expect(page).to have_no_content('Remove file')
        end
      end
    end
  end

  context 'Anauthenticated user' do
    before { visit question_path(question) }

    scenario 'no see remove attach option' do
      expect(page).to have_no_content('Remove file')
    end
  end
end
