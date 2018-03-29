FactoryBot.define do
  factory :answer do
    body "ValidBodyText"
    association :question, title: "ValidTitle"
  end

  factory :invalid_answer, class: Answer do
    body nil
    question_id nil
  end
end
