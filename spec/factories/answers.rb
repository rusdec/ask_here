FactoryBot.define do
  factory :answer do
    sequence :body do |n|
      "ValidAnswerBodyText#{n}"
    end
  end

  factory :best_answer, class: Answer do
    sequence :body do |n|
      "ValidAnswerBodyText#{n}"
    end
    
    best true
  end

  factory :invalid_answer, class: Answer do
    body nil
  end
end
