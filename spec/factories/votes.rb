FactoryBot.define do
  factory :vote do
    votable_id 1
    votable_type "Question"
  end

  factory :question_vote, class: Vote do
    votable_id 1
    votable_type "Question"
  end

  factory :answer_vote, class: Vote do
    votable_id 1
    votable_type "Answer"
  end
end
