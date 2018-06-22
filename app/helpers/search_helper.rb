module SearchHelper
  def question_link(resource)
    case resource
    when Question then link_to resource.title, question_path(resource)
    when Answer then link_to resource.question.title, question_path(resource.question)
    when Comment then question_link(resource.commentable)
    end
  end

  def select_searchable_context(form)
    html_form = form.select :context,
                            options_for_select(searchable_context, @raw_context),
                            {},
                            { class: 'custom-select', id: 'input-search-context' }

    "#{input_label(for: 'input-search-context', text: 'Context')}#{html_form}".html_safe
  end

  def searchable_context
    contexts = %w(question answer comment all)
    contexts.map { |context| [context, context] }
  end

  def select_per_page(form)
    html_form = form.select :per_page,
                            options_for_select(per_page_count, @per_page),
                            {},
                            { class: 'custom-select', id: 'input-per-page' }
    "#{input_label(for: 'input-per-page', text: 'Per page')}#{html_form}".html_safe
  end

  def per_page_count
    %w(5 20 50 100).map { |count| [count, count] }
  end

  def input_label(params = { for: '', text: '' })
    html_label = content_tag :lable, class: 'input-group-text', for: params[:for] do
                   params[:text]
                 end
    html_label = content_tag :div, class: 'input-group-prepend' do
                   html_label
                 end
    html_label
  end
end
