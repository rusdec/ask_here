class Api::V1::AnswersController < Api::V1::BaseController
  before_action :set_answers, only: :index
  before_action :set_answer, only: %i[show]

  authorize_resource

  def index
    respond_with(@answers, each_serializer: AnswersSerializer)
  end

  def show
    respond_with(@answer)
  end

  private

  def set_answers
    @answers = Answer.where(question_id: params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end
end
