module Commented
  extend ActiveSupport::Concern
  include JsonResponsed

  included do
    before_action :set_comment, only: %i[destroy_comment update_comment]
    before_action :set_commentable, only: %i[create_comment]

    def create_comment
      if current_user
        comment = current_user.comments.build(comment_params.merge(commentable: @commentable))
        json_response_by_result(comment.save, comment)
      else
        json_response_you_can_not_do_it
      end
    end

    private

    def set_commentable
      @commentable = commentable_klass.find(params[commentable_id])
    end

    def comment_params
      params.require(:comment).permit(:body)
    end

    def commentable_klass
      controller_name.classify.constantize
    end

    def commentable_id
      "#{controller_name.singularize}_id".to_sym
    end
  end
end
