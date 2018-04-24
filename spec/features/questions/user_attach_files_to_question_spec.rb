require_relative '../features_helper'

feature 'User can attach files to question', %q{
  As author of question
  I can attach any files to question
  so that I can clarify the my problem
} do

  given(:question_attributes) { attributes_for(:question) }
  given(:files) do
    { 'restart.txt' => "#{Rails.root}/tmp/restart.txt",
      'LICENSE' => "#{Rails.root}/LICENSE" }
  end

  before { sign_in(create(:user)) }

  scenario 'Authenticated user can attach one or more files', js: true do
    question_attributes[:files] = files
    create_question_with_files(question_attributes)

    files.each do |file_name, _|
      expect(page).to have_content(file_name)
    end
  end
end
