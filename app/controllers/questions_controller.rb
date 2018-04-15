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
    if current_user.author_of?(@question)
      @question.destroy
      redirect_to questions_path, alert: 'Question delete success'
    else
      render :show
    end
  end

  def update
    if current_user.author_of?(@question) && @question.update(question_params)
      flash[:alert] = 'Question update success'
    end

    render :show
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def set_question
    @question = Question.find(params[:id])
  end
end
