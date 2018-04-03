FactoryBot.define do
  factory :answer do
    body "ValidAnswerBodyText"
    association :question, title: "ValidQuestionTitle"
  end

  factory :invalid_answer, class: Answer do
    body nil
    question_id nil
  end
end
