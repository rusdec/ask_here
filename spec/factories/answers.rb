FactoryBot.define do
  factory :answer do
    body "ValidAnswerBodyText"
  end

  factory :invalid_answer, class: Answer do
    body nil
    question_id nil
    user_id nil
  end
end
