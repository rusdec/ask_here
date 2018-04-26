require_relative '../features_helper'

feature 'User can delete attached files from answer', %q{
  As author of answer
  I can delete attached from answer
  so that no one will use this files
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  context 'Authenticated user' do
    given(:files) do
      [{ name: 'restart.txt', path: "#{Rails.root}/tmp/restart.txt" },
       { name: 'LICENSE', path: "#{Rails.root}/LICENSE" }]
    end

    context 'when create new answer' do
      given(:answer_attributes) { attributes_for(:answer) }

      scenario 'can delete attach one or more files', js: true do
        sign_in(user)
        visit question_path(question)

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
      before do
        create(:answer, user: user, question: question)
        sign_in(user)
        visit question_path(question)
      end

      context 'and edit created answer' do
        scenario 'can attach one or more files', js: true do
          within '.answers' do
            #attach files
            click_on 'Edit'
            attach_files_when_edit({ context: '.answer_editable_attachements',
                                     files: files })
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
        create(:answer, user: user, question: question)
        sign_in(create(:user))
        visit question_path(question)
      end

      scenario 'no see remove attach option' do
        within '.answers' do
          expect(page).to have_no_content('Remove file')
        end
      end
    end
  end

  context 'Anauthenticated user' do
    before do
      create(:answer, user: user, question: question)
      visit question_path(question)
    end

    scenario 'no see remove attach option' do
      visit question_path(question)

      expect(page).to have_no_content('Remove file')
    end
  end
end
