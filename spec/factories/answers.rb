FactoryBot.define do
  factory :answer do
    sequence :body do |n|
      "ValidAnswerBodyText#{n}"
    end
    
    best false
  end

  factory :best_answer, class: Answer do
    sequence :body do |n|
      "ValidAnswerBodyText#{n}"
    end
    
    best true
  end

  factory :invalid_answer, class: Answer do
    body nil
    question_id nil
    user_id nil
  end
end
