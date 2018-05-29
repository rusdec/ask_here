class Api::V1::AnswersController < Api::V1::BaseController
  before_action :set_question, only: :create
  before_action :set_answers, only: :index
  before_action :set_answer, only: %i[show]

  authorize_resource

  def index
    respond_with(@answers, each_serializer: AnswersSerializer)
  end

  def show
    respond_with(@answer)
  end

  def create
    respond_with(@answer = current_resource_owner.answers.create(
      answer_params.merge(question: @question)))
  end

  private

  def set_answers
    @answers = Answer.where(question_id: params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
