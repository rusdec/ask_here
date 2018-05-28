class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :set_questions, only: :index

  def index
    authorize! :read, Question
    respond_with(@questions)
  end

  private

  def set_questions
    @questions = Question.all
  end
end
