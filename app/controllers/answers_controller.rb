class AnswersController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy update]
  before_action :set_question, only: %i[create]
  before_action :set_answer, only: %i[destroy update]

  def create
    @answer = current_user.answers.new(answer_params)
    @answer.question = @question
    @answer.save
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

  def update
    @answer.update(answer_params) if current_user.author_of?(@answer)
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
