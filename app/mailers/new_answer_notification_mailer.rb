class NewAnswerNotificationMailer < ApplicationMailer
  def notify(params)
    @answer = params[:answer]
    @question = @answer.question
    mail to: params[:user].email, subject: 'Ask question: New answer for question' 
  end
end
