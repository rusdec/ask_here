class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_question, only: %i[show destroy update]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.new
  end

  def new
    @question = current_user.questions.new
    @question.attachements.build
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, alert: 'Question create success'
    else
      render :new
    end
  end

  def destroy
    @result = @question.destroy if current_user.author_of?(@question)
  end

  def update
    @result = current_user.author_of?(@question) && @question.update(question_params)

    if @result
      flash[:alert] = 'Question update success'
    end
  end

  private

  def question_params
    params.require(:question).permit(:title,
                                     :body,
                                     attachements_attributes: [:id, :file, :_destroy])
  end

  def set_question
    @question = Question.find(params[:id])
  end
end
