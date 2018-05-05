module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_resource, only: %i[create_vote update_vote destroy_vote]
    before_action :set_vote, only: %i[update_vote destroy_vote]

    def create_vote
      resource = instance_variable_get('@resource')
      if current_user&.not_author_of?(resource)
        vote = current_user.votes.build(vote_params.merge(votable: resource))
        vote.save ? json_respond_vote_success('Vote create success')
                  : json_respond_vote_error(vote)
      else
        json_respond_you_can_not_vote
      end
    end

    def update_vote
      vote = instance_variable_get('@vote')
      if vote
        vote.update(vote_params) ? json_respond_vote_success('Vote update success')
                                 : json_respond_vote_error(vote.errors.full_messages)
      else
        json_respond_you_can_not_vote
      end
    end


    def destroy_vote
      vote = instance_variable_get('@vote')
      if vote
        vote.destroy ? json_respond_vote_success('Vote delete success')
                     : json_respond_vote_error(vote.errors.full_messages)
      else
        json_respond_you_can_not_vote
      end
    end

    private

    def json_respond_vote_success(message = '')
      respond_to do |format|
        format.json do
          render json: { status: true, message: message,
                         votes: resource_votes_count }
        end
      end
    end

    def json_respond_vote_error(messages = [])
      respond_to do |format|
        format.json do
          render json: { status: false, errors: messages }
        end
      end
    end

    def json_respond_you_can_not_vote
      json_respond_vote_error(['You can not vote for it'])
    end

    def resource_votes_count
      likes = instance_variable_get('@resource').likes.count
      dislikes = instance_variable_get('@resource').dislikes.count

      { likes: likes, dislikes: dislikes, rate: likes - dislikes }
    end

    def set_resource
      instance_variable_set('@resource', votable_klass.find(params[:id]))
    end

    def set_vote
      instance_variable_set('@vote', current_user.vote_for(instance_variable_get('@resource')))
    end

    def vote_params
      params.require(:vote).permit(:value)
    end

    def votable_klass
      controller_name.classify.constantize
    end
  end
end
