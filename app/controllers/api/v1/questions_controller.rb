class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :set_questions, only: :index
  before_action :set_question, only: %i[show]

  def index
    authorize! :read, Question
    respond_with(@questions)
  end

  def show
    authorize! :read, @question
    respond_with(@question)
  end

  private

  def set_questions
    @questions = Question.all
  end

  def set_question
    @question = Question.find(params[:id])
  end
end
