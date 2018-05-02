module VotesHelper

  def vote_links(params)
    params[:vote] ||= current_user.votes.build(votable: params[:resource])
    resource = params[:resource]
    vote = params[:vote]

    likes_count = resource.likes.count.to_s
    dislikes_count = resource.dislikes.count.to_s

    if vote.new_record?
      like = post_form(vote: vote,
                       resource: resource,
                       value: true,
                       count: likes_count,
                       button_text: like_button_text)

      dislike = post_form(vote: vote,
                          resource: resource,
                          value: false,
                          count: dislikes_count,
                          button_text: dislike_button_text)

    elsif vote.value?
        like = delete_form(vote: vote,
                           count: likes_count,
                           button_text: like_button_text)

        dislike = patch_form(vote: vote,
                             value: false,
                             count: dislikes_count,
                             button_text: dislike_button_text)

    else
        like = patch_form(vote: vote,
                          value: true,
                          count: likes_count,
                          button_text: like_button_text)

        dislike = delete_form(vote: vote,
                              count: dislikes_count,
                              button_text: dislike_button_text)
    end
    
    "#{like} #{dislike}".html_safe
  end

  def delete_form(params)
    form_for params[:vote], delete_options do |f|
      concat(f.label :value, params[:count]) if params[:count]
      concat(f.submit params[:button_text], class: 'red')
    end
  end

  def patch_form(params)
    form_for params[:vote], patch_options do |f|
      concat(f.label :value, params[:count]) if params[:count]
      concat(f.hidden_field :value, value: params[:value])
      concat(f.submit params[:button_text])
    end
  end

  def post_form(params)
    form_for params[:vote], post_options(params[:resource]) do |f|
      concat(f.label :value, params[:count]) if params[:count]
      concat(f.hidden_field :value, value: params[:value])
      concat(f.submit params[:button_text])
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
      rating = "+#{rating}" if rating > 0

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
