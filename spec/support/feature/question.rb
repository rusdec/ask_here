module Feature
  module Question

    def create_question_with_files(params)
      visit new_question_path
      fill_in 'Title', with: params[:title]
      fill_in 'Body', with: params[:body]
      attach_files(params[:files])
      click_on 'Create Question'
    end

    def attach_files(files)
      files.each do |_, file|
        within all('.question_attachement').last do
          attach_file 'File', file
        end
        click_on 'More file'
      end
    end

    def attach_files_when_edit(files)
      files.each do |_, file|
        within '.editable_question_attachements' do
          click_on 'More file'
        end
        within all('.question_attachement').last do
          attach_file 'File', file
        end
      end
    end

    def create_question(params)
      visit new_question_path
      fill_in 'Title', with: params[:title]
      fill_in 'Body', with: params[:body]
      click_on 'Create Question'
    end

    def update_question(params)
      visit question_path(params[:question])
      click_on 'Edit'
      within '.form-edit-question' do
        fill_in 'Title', with: params[:title]
        fill_in 'Body', with: params[:body]
        click_on 'Save'
      end
    end
  end
end
