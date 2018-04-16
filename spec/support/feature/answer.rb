module Feature
  module Answer
    def create_answer(params)
      visit question_path(params[:question])
      fill_in 'Body', with: params[:body]
      click_on 'Create Answer'
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

    def click_edit_answer_link(answer)
      within answer_container(answer) do
        click_on 'Edit'
      end
    end

    def click_cancel_edit_answer_link(answer)
      within answer_container(answer) do
        click_on 'Cancel'
      end
    end

    def click_delete_answer_link(answer)
      within answer_container(answer) do
        click_on 'Delete'
      end
    end

    def answer_body(answer)
      "#{answer_container(answer)} p.body"
    end

    def answer_edit_form(answer)
      "#{answer_container(answer)} .form-edit-answer"
    end

    def answer_edit_hidden_form(answer)
      "#{answer_edit_form(answer)}.hidden"
    end

    def answer_edit_link(answer)
      "#{answer_container(answer)} .link-edit-answer"
    end
  end
end
