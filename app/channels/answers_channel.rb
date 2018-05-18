class AnswersChannel < ApplicationCable::Channel
  def follow(data)
    stream_from "question_#{data['id']}" unless data['id'].nil?
  end
end
