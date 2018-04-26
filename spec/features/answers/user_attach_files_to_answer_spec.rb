require_relative '../features_helper'

feature 'User can attach files to answer', %q{
  As author of answer
  I can attach any files to answer
  so that I can better answer the question
} do

  given(:user) { create(:user) }
  given!(:question) do
    create(:question_with_answers, user: user, answers_count: 1)
  end

  given(:files) do
    [{ name: 'restart.txt', path: "#{Rails.root}/tmp/restart.txt" },
     { name: 'LICENSE', path: "#{Rails.root}/LICENSE" }]
  end

  context 'Authenticated user' do
    before { sign_in(user) }

    context 'when author of answer' do
      given(:answer_attributes) { attributes_for(:answer) }
      before { visit question_path(question) }

      context 'and create new answer' do
        scenario 'can attach one or more files', js: true do
          within '#new_answer' do
            fill_in 'Body', with: answer_attributes[:body]
            attach_files({ context: '.new_answer_attachements', files: files})
            click_on 'Create Answer'
          end

          files.each do |file|
            expect(page).to have_content(file[:name])
          end
        end
      end

      context 'and edit created answer' do
        scenario 'can attach one or more files', js: true do
          within '.answers' do
            click_on 'Edit'
            attach_files_when_edit({ context: '.answer_editable_attachements',
                                     files: files })
            click_on 'Save'
          end

          files.each do |file|
            expect(page).to have_content(file[:name])
          end
        end
      end

    end
  end
end
