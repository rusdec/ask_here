class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_question, only: %i[show update destroy]
  authorize_resource
  after_action :publish_questions, only: %i[create]

  respond_to :js, only: %i[update destroy]

  include Voted

  def index
    @questions = Question.order(created_at: :desc)
  end

  def show; end

  def new
    @question = current_user.questions.new
  end

  def create
    respond_with(@question = current_user.questions.create(question_params))
  end

  def destroy
    respond_with(@question.destroy)
  end

  def update
    @question.update(question_params)
    respond_with(@question)
  end

  private

  def publish_questions
    return if @question.errors.any?
    ActionCable.server.broadcast('questions',
      ApplicationController.render(
        partial: 'questions/question',
        locals: { question: @question }
      )
    )
  end

  def comment_stream_id
    params['question_id']
  end

  def question_params
    params.require(:question).permit(:title, :body,
                                     attachements_attributes: [:id, :file, :_destroy])
  end

  def set_question
    @question = Question.find(params[:id])
    gon.question_id = @question.id
    gon.question_user_id = @question.user.id
  end
end
