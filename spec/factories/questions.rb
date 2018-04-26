FactoryBot.define do
  factory :question do
    sequence :title do |n|
      "ValidQuestionTitle#{n}"
    end

    sequence :body do |n|
      "ValidQuestionBodyText#{n}"
    end

    factory :question_with_answers do
      transient { answers_count 2 }

      after(:create) do |question, evaluator|
        create_list(:answer, evaluator.answers_count, question: question, user: question.user)
      end
    end
  end

  factory :invalid_question, class: Question do
    title nil
    body "ShortText"
    user nil
  end
end
