module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: %i[create_vote update_vote destroy_vote]
    before_action :set_vote, only: %i[update_vote destroy_vote]

    def create_vote
      if current_user&.not_author_of?(@votable)
        vote = current_user.votes.build(vote_params.merge(votable: @votable))
        vote.save ? json_respond_vote_success('Vote create success')
                  : json_respond_vote_error(vote)
      else
        json_respond_you_can_not_vote
      end
    end

    def update_vote
      if @vote
        @vote.update(vote_params) ? json_respond_vote_success('Vote update success')
                                  : json_respond_vote_error(@vote.errors.full_messages)
      else
        json_respond_you_can_not_vote
      end
    end


    def destroy_vote
      if @vote
        @vote.destroy ? json_respond_vote_success('Vote delete success')
                      : json_respond_vote_error(@vote.errors.full_messages)
      else
        json_respond_you_can_not_vote
      end
    end

    private

    def json_respond_vote_success(message = '')
      render json: { status: true, message: message,
                     votes: @votable.rating }
    end

    def json_respond_vote_error(messages = [])
      render json: { status: false, errors: messages }
    end

    def json_respond_you_can_not_vote
      json_respond_vote_error(['You can not vote for it'])
    end

    def set_votable
      @votable = votable_klass.find(params[:id])
    end

    def set_vote
      @vote = current_user.vote_for(@votable)
    end

    def vote_params
      params.require(:vote).permit(:value)
    end

    def votable_klass
      controller_name.classify.constantize
    end
  end
end
