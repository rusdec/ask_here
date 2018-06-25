module InlineEditHelper
  def inline_edit_element(args)
    args[:params] ||= {}
    args[:params] = default_params.merge(args[:params])

    "#{inline_edit_links(args)}#{inline_edit_mode(args)}#{inline_edit_data(args)}".html_safe
  end

  def inline_edit_data(args)
    content_tag :div, class: 'inline-edit-data' do
      concat(args[:data])
    end
  end

  def inline_edit_links(args)
    content_tag :div, class: 'links small' do
      concat(args[:additional_links]) if args[:additional_links]
      concat(link_to 'Edit', 'javascript:void(0)',
                             { class: 'link-edit' }.merge(args[:params][:edit_link_params]))
      concat(link_to 'Cancel', 'javascript:void(0)',
                             { class: 'link-cancel hidden' }.merge(args[:params][:cancel_link_params]))
      concat(tag.span '', class: 'delim')
      concat(link_to 'Delete', polymorphic_path(args[:resource]),
                               { class: 'link-delete',
                                 method: :delete,
                                 remote: true }.merge(args[:params][:delete_link_params]))
    end
  end

  def inline_edit_mode(args)
    content_tag :div, class: 'inline-edit-mode hidden' do
      concat(args[:form])
    end
  end

  def default_params
    { delete_link_params: {},
      edit_link_params: {},
      cancel_link_params: {} }
  end
end
