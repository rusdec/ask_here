FactoryBot.define do
  sequence :email do |n|
    "user#{n}@email.ru"
  end

  factory :user do
    email
    password 'Qwerty123'    
    confirmed_at Time.now

    transient do
      questions_count 1
      answers_count 1
    end

    factory :user_with_questions do
      after(:create) do |user, evaluator|
        create_list(:question, evaluator.questions_count, user: user)
      end
    end

    factory :user_with_question_and_answers do
      after(:create) do |user, evaluator|
        question = create(:question, user: user)
        create_list(:answer, evaluator.answers_count, user: user, question: question)
      end
    end

    factory :user_with_question_and_best_answer do
      after(:create) do |user, evaluator|
        question = create(:question, user: user)
        create(:answer, user: user, question: question)
        create(:best_answer, user: user, question: question)
      end
    end
  end
end
