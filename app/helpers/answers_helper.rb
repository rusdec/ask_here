module AnswersHelper
  def delete_answer_link(answer)
    if current_user&.author_of?(answer) 
      link_to 'Delete', answer_path(answer), method: :delete
    end
  end
end
