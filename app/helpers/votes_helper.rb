module VotesHelper
  def vote_links(question)
    return "" if current_user.nil? || current_user.author_of?(question)

    vote = current_user.vote_for(question) || current_user.votes.build(votable: question)

    likes_count = question.likes.count
    dislikes_count = question.dislikes.count

    if vote.persisted?
      if vote.value?
        like = form_for vote, remote: true, method: :delete do |f|
          concat(f.label :value, likes_count.to_s)
          concat(f.submit like_button_text, class: 'red')
        end
        dislike = form_for vote, remote: true, class: 'red' do |f|
          concat(f.label :value, dislikes_count.to_s)
          concat(f.hidden_field :value, value: false)
          concat(f.submit dislike_button_text)
        end
      else
        like = form_for vote, remote: true, class: 'red' do |f|
          concat(f.label :value, likes_count.to_s)
          concat(f.hidden_field :value, value: true)
          concat(f.submit like_button_text)
        end
        dislike = form_for vote, remote: true, method: :delete do |f|
          concat(f.label :value, dislikes_count.to_s)
          concat(f.submit dislike_button_text, class: 'red')
        end
      end
    else
      like = form_for vote, url: polymorphic_path([question, :votes]), remote: true do |f|
        concat(f.label :value, likes_count.to_s)
        concat(f.hidden_field :value, value: true)
        concat(f.submit like_button_text)
      end
      dislike = form_for vote, url: polymorphic_path([question, :votes]), remote: true do |f|
        concat(f.label :value, dislikes_count.to_s)
        concat(f.hidden_field :value, value: false)
        concat(f.submit dislike_button_text)
      end
    end
    
    "#{like} #{dislike}".html_safe
  end

  def vote_rating(resource)
    content_tag 'span' do
      rating = resource.likes.count - resource.dislikes.count
      if rating > 0
        "+#{rating}"
      else
        "#{rating}"
      end
    end
  end

  def like_button_text
    'Like'
  end

  def dislike_button_text
    'Dislike'
  end

  def vote_container_klass_name(resource)
    "vote_#{resource.class.to_s.downcase}_#{resource.id}"
  end
end
