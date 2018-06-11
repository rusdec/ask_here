module SearchHelper
  def question_link(resource)
    case resource
    when Question then link_to resource.title, question_path(resource)
    when Answer then link_to resource.question.title, question_path(resource.question)
    when Comment then question_link(resource.commentable)
    end
  end

  def select_searchable_context(form)
    form.select :resource,
                options_from_collection_for_select(searchable_context, :name, :name)
  end

  def searchable_context
    contexts = %i(question answer comment all)
    contexts.map { |context| OpenStruct.new(name: context) }
  end

  def select_per_page(form)
    form.select :per_page,
                options_from_collection_for_select(per_page_count, :count, :count)
  end

  def per_page_count
    %w(20 50 100).map { |count| OpenStruct.new(count: count) }
  end
end