module Feature
  module Answer
    def create_answer(params)
      visit question_path(params[:question])

      within '#new_answer' do
        fill_in 'Body', with: params[:body]
        click_on 'Create Answer'
      end
    end

    def answer_container(answer)
      ".answer[data-id='#{answer.id}']"
    end

    def update_answer(params)
      visit question_path(params[:question])

      within answer_container(params[:answer]) do
        click_on 'Edit'
        fill_in 'Body', with: params[:body]
        click_on 'Save'
      end
    end

    def attach_files_to_answer_when_edit(files)
      within '.editable_answer_attachements' do
        files.each do |_, file|
          click_on 'More file'
          within all('.answer_attachement').last do
            attach_file 'File', file
          end
        end
      end
    end

    def attach_files_to_answer(files)
      within '.new_answer_attachements' do
        files.each do |_, file|
          within all('.answer_attachement').last do
            attach_file 'File', file
          end
          click_on 'More file'
        end
      end
    end

    def click_edit_answer_link(answer)
      within answer_container(answer) do
        click_on 'Edit'
      end
    end

    def click_delete_answer_link(answer)
      within answer_container(answer) do
        click_on 'Delete'
      end
    end

    def click_set_as_best_answer_link(answer)
      within answer_container(answer) do
        click_on 'Best answer'
      end
    end

    def click_set_as_not_best_answer_link(answer)
      within answer_container(answer) do
        click_on 'Not a Best'
      end
    end

    def best_answer_id
      '#best_answer'
    end

    def answer_edit_form(answer)
      "#{answer_container(answer)} .form-edit-answer"
    end
  end
end
