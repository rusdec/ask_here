class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :set_questions, only: :index
  before_action :set_question, only: %i[show]
  authorize_resource

  def index
    respond_with(@questions, each_serializer: QuestionsSerializer)
  end

  def show
    respond_with(@question)
  end

  def create
    respond_with(@question = current_resource_owner.questions.create(question_params))
  end

  private

  def set_questions
    @questions = Question.all
  end

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
