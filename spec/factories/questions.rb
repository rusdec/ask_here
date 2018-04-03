FactoryBot.define do
  factory :question do
    title "ValidQuestionTitle"
    body "ValidQuestionBodyText"
  end

  factory :invalid_question, class: Question do
    title nil
    body "ShortText"
  end
end
