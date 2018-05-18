class CommentsChannel < ApplicationCable::Channel
  def follow(data)
    unless data['commentable_id'].nil? && data['commentable_type'].nil?
      stream_from "comments_#{data['commentable_type']}_#{data['commentable_id']}"
    end
  end
end
