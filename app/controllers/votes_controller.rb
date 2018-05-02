class VotesController < ApplicationController
  before_action :set_vote, except: :create
  before_action :set_resource, only: :create

  def create
    if current_user&.not_author_of?(@resource)
      @vote = current_user.votes.build(votable: @resource,
                                       value: vote_params[:value])
      @vote.save!
    end
  end

  def update
    @result = @vote.update(vote_params) if current_user&.author_of?(@vote)
  end

  def destroy
    @vote.destroy if current_user&.author_of?(@vote)
  end

  private

  def set_vote
    @vote = Vote.find(params[:id])
  end

  def vote_params
    params.require(:vote).permit(:value)
  end

  def set_resource
    if params[:question_id]
      @resource = Question.find(params[:question_id])
    else
      @resource = Answer.find(params[:answer_id])
    end
  end
end
