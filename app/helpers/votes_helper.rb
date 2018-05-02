module VotesHelper
  def vote_forms(params)
    params[:vote] ||= current_user.votes.build(votable: params[:resource])
    get_forms(params[:vote], params[:resource]).html_safe
  end

  def get_forms(vote, resource)
    like_params = like_params_for(vote, resource)
    dislike_params = dislike_params_for(vote, resource)

    if vote.new_record?
      "#{post_form(like_params)} #{post_form(dislike_params)}"
    elsif vote.value?
      "#{delete_form(like_params)} #{patch_form(dislike_params)}"
    else
      "#{patch_form(like_params)} #{delete_form(dislike_params)}"
    end
  end

  def like_params_for(vote, resource)
    { vote: vote,
      resource: resource,
      count: resource.likes.count.to_s,
      button_text: like_button_text,
      value: true }
  end

  def dislike_params_for(vote, resource)
    { vote: vote,
      resource: resource,
      count: resource.dislikes.count.to_s,
      button_text: dislike_button_text,
      value: false }
  end

  def delete_form(params)
    form_for params[:vote], delete_options do |f|
      concat(f.label(:value, params[:count])) if params[:count]
      concat(f.submit(params[:button_text], class: 'red'))
    end
  end

  def patch_form(params)
    form_for params[:vote], patch_options do |f|
      concat(f.label(:value, params[:count])) if params[:count]
      concat(f.hidden_field(:value, value: params[:value]))
      concat(f.submit(params[:button_text]))
    end
  end

  def post_form(params)
    form_for params[:vote], post_options(params[:resource]) do |f|
      concat(f.label(:value, params[:count])) if params[:count]
      concat(f.hidden_field(:value, value: params[:value]))
      concat(f.submit(params[:button_text]))
    end
  end

  def patch_options
    { remote: true }
  end

  def delete_options
    { remote: true, method: :delete }
  end

  def post_options(resource)
    { url: polymorphic_path([resource, :votes]), remote: true }
  end

  def vote_rating(resource)
    content_tag 'span' do
      rating = resource.likes.count - resource.dislikes.count
      rating = "+#{rating}" if rating.positive?

      rating.to_s
    end
  end

  def like_button_text
    'Like'
  end

  def dislike_button_text
    'Dislike'
  end

  def vote_container_klass_name(resource)
    "vote-#{resource.class.to_s.downcase}-#{resource.id}"
  end
end
