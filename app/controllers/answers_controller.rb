class AnswersController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy update best_answer]
  before_action :set_question, only: %i[create]
  before_action :set_answer, only: %i[destroy update best_answer]

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

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end
end
