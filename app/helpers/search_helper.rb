module SearchHelper
  def question_link(resource)
    case resource
    when Question then link_to resource.title, question_path(resource)
    when Answer then link_to resource.question.title, question_path(resource.question)
    when Comment then question_link(resource.commentable)
    end
  end

  def select_searchable_context(form)
    form.select :context, options_for_select(searchable_context, @raw_context)
  end

  def searchable_context
    contexts = %w(question answer comment all)
    contexts.map { |context| [context, context] }
  end

  def select_per_page(form)
    form.select :per_page, options_for_select(per_page_count, @per_page)
  end

  def per_page_count
    %w(20 50 100).map { |count| [count, count] }
  end
end
