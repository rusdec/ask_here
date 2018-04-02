FactoryBot.define do
  sequence :email do |n|
    "user#{n}@email.ru"
  end

  factory :user do
    email
    password 'Qwerty123'    
  end
end
