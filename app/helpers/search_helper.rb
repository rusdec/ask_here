module SearchHelper
  def question_link(resource)
    link = case resource.class
    when Question then link_to resource.title, question_path(resource)
    when Answer then link_to resource.question.title, question_path(resource.question)
    when Comment then question_link(resource.commentable)
    end
    puts '*'*10
    puts resource.class
    puts resource.question.title
    puts question_path(resource.question)
    puts link_to resource.question.title, question_path(resource.question)
    puts '*'*10
    link
  end

  def select_searchable_context(form)
    form.select :resource,
                options_from_collection_for_select(searchable_context, :name, :name)
  end

  def searchable_context
    contexts = %i(question answer)
      
    contexts.map do |context|
      OpenStruct.new(name: context)
    end
  end
end
