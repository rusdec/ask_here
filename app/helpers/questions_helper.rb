module QuestionsHelper
  def actions_with_question(question)
    if current_user&.author_of?(question) 
      link_to 'Delete Question', question_path(question), method: :delete
      link_to 'Edit Question', '#', class: 'link-edit', data: { question_id: question.id }
    end
  end

  def delete_question_link(question)
    actions_with_question(question)
  end
end
