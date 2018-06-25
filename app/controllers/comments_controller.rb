class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_comment, except: %i[create]
  before_action :set_commentable, only: %i[create]
  authorize_resource

  after_action :publish_comment, only: %i[create update]

  include JsonResponsed

  def create
    @comment = current_user.comments.create(comment_params.merge(commentable: @commentable))
    json_response_by_result
  end

  def destroy
    @comment.destroy
    json_response_by_result
  end

  def update
    @comment.update(comment_params)
    json_response_by_result
  end

  private

  def publish_comment
    return if @comment.nil? || @comment.errors.any?
    ActionCable.server.broadcast(stream_name, {
      comment: @comment,
      commentable_id: @comment.commentable_id,
      commentable_type: @comment.commentable_type.underscore,
      user_email: @comment.user.email,
      created_at: @comment.created_at.strftime('%d.%m.%Y')
    })
  end
  
  def set_comment
    @comment = Comment.find_by(id: params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def set_commentable
    @commentable = commentable_klass.find(params[commentable_id_param])
  end

  def commentable_klass
    commentable_id_param[0...-3].classify.constantize
  end

  def commentable_id_param
    params.keys.select { |key| key[-3..-1] == '_id' }[0]
  end

  def stream_name
    "comments_#{@comment.commentable_type.underscore}_#{@comment.commentable_id}"
  end
end
