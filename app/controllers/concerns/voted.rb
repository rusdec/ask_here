module Voted
  extend ActiveSupport::Concern
  include JsonResponsed

  included do
    before_action :set_votable, only: %i[add_vote cancel_vote]
    before_action :set_vote, only: %i[cancel_vote]

    def add_vote
      authorize! :add_vote, @votable
      @vote = current_user.votes.vote!(vote_params.merge(votable: @votable))
      json_response_by_result({ votes: @votable.rating }, @vote)
    end

    def cancel_vote
      authorize! :cancel_vote, @vote
      @vote.destroy
      json_response_by_result({ votes: @votable.rating }, @vote)
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
