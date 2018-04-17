module AnswersHelper
  def answer_remote_links(answer)
    content_tag :div, class: 'answer-remote-links', data: { answer_id: answer.id } do
      concat(link_to 'Best answer',
             best_answer_answer_path(answer),
             class: 'link-set-as_best-answer',
             remote: true,
             method: :patch)

      concat(link_to 'Edit', '#', class: 'link-edit-answer') 

      concat(link_to 'Delete',
             answer_path(answer),
             method: :delete,
             class: 'link-delete-answer',
             remote: true)
    end
  end
end
