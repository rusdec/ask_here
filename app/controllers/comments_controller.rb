class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_comment

  include JsonResponsed

  def destroy
    @comment ? json_response_by_result(@comment.destroy, @comment)
             : json_response_you_can_not_do_it
  end

  def update
   @comment ? json_response_by_result(@comment.update(comment_params), @comment)
            : json_respond_you_can_not_do_it
  end

  private

  def set_comment
    @comment = current_user.comments.find_by(id: params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
