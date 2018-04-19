module AnswersHelper
  def answer_remote_links(answer)
    content_tag :div, class: 'answer-remote-links', data: { answer_id: answer.id } do
        concat(link_to 'Not a Best',
               not_best_answer_answer_path(answer),
               class: "link-unset-best-answer #{'hidden' unless answer.best?}",
               remote: true,
               method: :patch)

        concat(link_to 'Best answer',
               best_answer_answer_path(answer),
               class: "link-set-as-best-answer #{'hidden' if answer.best?}",
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
