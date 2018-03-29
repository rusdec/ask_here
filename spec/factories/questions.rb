FactoryBot.define do
  factory :question do
    title "ValidTitle"
    body "TextOfQuestionBody"
  end

  factory :invalid_question, class: Question do
    title nil
    body "ShortText"
  end
end
