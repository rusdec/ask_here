class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: %i[create]
  before_action :set_answer, except: %i[create]

  def create
    @answer = current_user.answers.new(answer_params)
    @answer.question = @question
    @answer.save
  end

  def destroy
    @answer.destroy if current_user.author_of?(@answer)
  end

  def update
    @result = @answer.update(answer_params) if current_user.author_of?(@answer)
  end

  def best_answer
    @answer.best! if current_user.author_of?(@answer.question)
  end

  def not_best_answer
    @answer.not_best! if current_user.author_of?(@answer.question)
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachements_attributes: [:id, :file])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end
end
