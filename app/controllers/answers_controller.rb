class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: %i[create]
  before_action :set_answer, except: %i[create]

  after_action :publish_answers, only: %i[create update]

  include Voted
  include JsonResponsed

  def create
    @answer = current_user.answers.new(answer_params.merge(question: @question))
    @answer.save
    json_response_by_result
  end

  def destroy
    @answer.destroy if current_user.author_of?(@answer)
  end

  def update
    if current_user.author_of?(@answer)
      @answer.update(answer_params)
      json_response_by_result
    else
      json_response_you_can_not_do_it
    end
  end

  def best_answer
    @answer.best! if current_user.author_of?(@answer.question)
  end

  def not_best_answer
    @answer.not_best! if current_user.author_of?(@answer.question)
  end

  private

  def publish_answers
    return if @answer.errors.any?
    ActionCable.server.broadcast("question_#{@answer.question.id}", {
      answer: @answer,
      votes: @answer.rating,
      attachements: @answer.attachements,
      comments: @answer.comments
    })
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body,
                                   attachements_attributes: [:id, :file, :_destroy])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end
end
