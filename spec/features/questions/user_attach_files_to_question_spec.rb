require_relative '../features_helper'

feature 'User can attach files to question', %q{
  As author of question
  I can attach any files to question
  so that I can clarify the my problem
} do

  given(:user) { create(:user) }
  given(:question_attributes) { attributes_for(:question) }
  given(:files) do
    { 'restart.txt' => "#{Rails.root}/tmp/restart.txt",
      'LICENSE' => "#{Rails.root}/LICENSE" }
  end


  context 'Authenticated user' do
    before { sign_in(user) }

    context 'when author of question' do

      context 'and create new question' do
        scenario 'can attach one or more files', js: true do
          question_attributes[:files] = files
          create_question_with_files(question_attributes)

          files.each do |file_name, _|
            expect(page).to have_content(file_name)
          end
        end
      end

      context 'and edit created question' do
        given!(:question) { create(:question, user: user) }
        scenario 'can attach one or more files', js: true do
          visit question_path(question)
          click_on 'Edit'
          attach_files_when_edit(files)
          click_on 'Save'
          
          files.each do |file_name, _|
            expect(page).to have_content(file_name)
          end
        end
      end

    end
  end
end
