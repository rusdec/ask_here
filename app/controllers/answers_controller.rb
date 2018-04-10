class AnswersController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]
  before_action :set_question, only: %i[create]
  before_action :set_answer, only: %i[destroy]

  def create
    @answer = current_user.answers.new(answer_params)
    @answer.question = @question

    if @answer.save
      redirect_to @question
    else
      render 'questions/show'
    end
  end

  def destroy
    flash_message = if current_user.author_of?(@answer)
                      @answer.destroy
                      'Answer delete success' 
                    else
                      'Answer delete error'
                    end
    
    redirect_to @answer.question, alert: flash_message
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
