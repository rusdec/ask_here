require_relative '../features_helper'

feature 'User can delete attached files from answer', %q{
  As author of answer
  I can delete attached from answer
  so that no one will use this files
} do

  given!(:user) { create(:user) }
  given(:files) do
    { 'restart.txt' => "#{Rails.root}/tmp/restart.txt",
      'LICENSE' => "#{Rails.root}/LICENSE" }
  end
  given(:answer_attributes) { attributes_for(:answer) }
  given!(:question) { create(:question, user: user) }

  context 'Authenticated user' do
    before { sign_in(user) }

    context 'when create new answer' do
      scenario 'can delete attach one or more files', js: true do
        visit question_path(question)

        within '#new_answer' do
          fill_in 'Body', with: answer_attributes[:body]
          attach_files_to_answer(files)
          
          (files.count + 1).times do
            within all('.answer_attachement').last do
              click_on 'Remove file'
            end
          end

          click_on 'Create Answer'
        end
        
        files.each do |file_name, _|
          expect(page).to have_no_content(file_name)
        end
      end
    end

    context 'when author of answer' do
      before do
        create(:answer, user: user, question: question)
        visit question_path(question)
      end

      context 'and edit created answer' do
        scenario 'can attach one or more files', js: true do
          within '.answers' do
            #attach files
            click_on 'Edit'
            attach_files_to_answer_when_edit(files)
            click_on 'Save'

            #remove attached files
            click_on 'Edit'
            all('.editable_answer_attachement').each do |answer|
              within answer do
                check 'Remove file'
              end
            end

            click_on 'Save'
          end

          files.each do |file_name, _|
            expect(page).to have_no_content(file_name)
          end
        end
      end
    end

  end
end
