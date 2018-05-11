module Voted
  extend ActiveSupport::Concern
  include JsonResponsed

  included do
    before_action :set_votable, only: %i[add_vote cancel_vote]
    before_action :set_vote, only: %i[cancel_vote]

    def add_vote
      if current_user&.not_author_of?(@votable)
        vote = current_user.votes.vote!(vote_params.merge(votable: @votable))
        json_response_by_result(vote.persisted?, vote, { votes: @votable.rating })
      else
        json_response_you_can_not_do_it
      end
    end

    def cancel_vote
      if @vote
        json_response_by_result(@vote.destroy, @vote, { votes: @votable.rating })
      else
        json_response_you_can_not_do_it
      end
    end

    private

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
