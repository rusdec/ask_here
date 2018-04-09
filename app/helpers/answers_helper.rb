module AnswersHelper
  def delete_answer_element(answer)
    if current_user && current_user.answer_author?(answer) 
      link_to 'Delete', answer_path(answer), method: :delete, author: answer.user.id
    end
  end
end
