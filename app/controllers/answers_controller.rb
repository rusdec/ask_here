class AnswersController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]
  before_action :set_question, only: %i[index create]
  before_action :set_answer, only: %i[destroy]

  def index
    @answers = @question.answers
  end

  def create
    @answer = current_user.answers.new(answer_params)
    @answer.question_id = @question.id

    if @answer.save
      redirect_to question_path(@question)
    else
      render 'questions/show'
    end
  end

  def destroy
    flash_message = if current_user.answer_author?(@answer)
                      @answer.destroy
                      { alert: 'Answer delete success' }
                    else
                      {}
                    end
    
    redirect_to question_path(@answer.question), flash_message
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, :question_id)
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end
end
