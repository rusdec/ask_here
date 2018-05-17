class CommentsChannel < ApplicationCable::Channel
  def follow(data)
    unless data['id'].nil? && data['commentable_type'].nil?
      stream_from "comments_#{data['commentable_type']}_#{data['id']}"
    end
  end
end
