FactoryBot.define do
  factory :vote do
    votable_id 1
    votable_type "Question"
    value 1
  end

  factory :question_vote, class: Vote do
    votable_id 1
    votable_type "Question"
    value 1
  end

  factory :answer_vote, class: Vote do
    votable_id 1
    votable_type "Answer"
    value 1
  end
end
