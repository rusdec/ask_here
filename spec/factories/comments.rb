FactoryBot.define do
  factory :comment do
    sequence :body do |n|
      "ValidCommentBodyText#{n}"
    end
  end

  factory :invalid_comment, class: Comment do
    body nil
  end
end
