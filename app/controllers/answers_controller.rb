class AnswersController < ApplicationController
  before_action :set_question, only: %i[index new create]
  before_action :authenticate_user!, only: %i[create]

  def index
    @answers = @question.answers
  end

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    
    if @answer.save
      redirect_to question_path(@question)
    else
      render 'questions/show'
    end
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    puts params.require(:answer).permit(:body).inspect
    params.require(:answer).permit(:body)
  end
end
