module AnswersHelper
  def best_answer_links(answer)
    if can?(:best_answer_actions, answer)
      content_tag :div, class: 'best-answer-links', data: { answer_id: answer.id } do
        concat(link_to 'Not a Best',
               not_best_answer_answer_path(answer),
               class: "link-unset-best-answer #{'hidden' if answer.not_best?}",
               remote: true,
               method: :patch)

        concat(link_to 'Best answer',
               best_answer_answer_path(answer),
               class: "link-set-as-best-answer #{'hidden' if answer.best?}",
               remote: true,
               method: :patch)
      end
    end
  end
end
