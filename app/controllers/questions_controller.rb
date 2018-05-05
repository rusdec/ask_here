class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_question, except: %i[new create index]

  include Voted

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
    @result = @question.destroy if current_user.author_of?(@question)
  end

  def update
    @result = current_user.author_of?(@question) && @question.update(question_params)
  end

  private

  def question_params
    params.require(:question).permit(:title, :body,
                                     attachements_attributes: [:id, :file, :_destroy])
  end

  def set_question
    @question = Question.find(params[:id])
  end
end
