require_relative '../features_helper'

feature 'User can attach files to answer', %q{
  As author of answer
  I can attach any files to answer
  so that I can better answer the question
} do

  given(:user) { create(:user) }
  given(:question) do
    create(:question_with_answers, user: user, answers_count: 1)
  end


  context 'Authenticated user' do
    given(:files) do
      [{ name: 'restart.txt', path: "#{Rails.root}/tmp/restart.txt" },
       { name: 'LICENSE', path: "#{Rails.root}/LICENSE" }]
    end
    before do
      sign_in(user)
      visit question_path(question)
    end

    context 'when create new answer' do
      given(:answer_attributes) { attributes_for(:answer) }

      scenario 'can attach one or more files', js: true do
        create_answer(answer_attributes) do
          attach_files({ context: '.new_answer_attachements', files: files})
        end

        files.each do |file|
          expect(page).to have_content(file[:name])
        end
      end
    end

    context 'when author of answer' do
      context 'and edit created answer' do
        scenario 'can attach one or more files', js: true do
          within '.answers' do
            click_on 'Edit'
            attach_files({ context: '.answer_editable_attachements', files: files })
            click_on 'Save'
          end

          files.each do |file|
            expect(page).to have_content(file[:name])
          end
        end
      end
    end

    context 'when not author of answer' do
      before do
        visit question_path(create(:question_with_answers, user: create(:user)))
      end

      scenario 'no see add file option' do
        within '.answers' do
          expect(page).to have_no_content('Add file')
        end
      end
    end
  end

  context 'Unauthenticated user' do
    before { visit question_path(question) }

    scenario 'no see add file option' do
      expect(page).to have_no_content('Add file')
    end
  end
end
