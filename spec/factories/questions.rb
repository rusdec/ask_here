FactoryBot.define do
  factory :question do
    title "ValidQuestionTitle"
    body "ValidQuestionBodyText"

    factory :question_with_answers do
      transient { answers_count 2 }

      after(:create) do |question, evaluator|
        create_list(:answer, evaluator.answers_count, question: question)
      end
    end
  end

  factory :invalid_question, class: Question do
    title nil
    body "ShortText"
    user nil
  end
end
