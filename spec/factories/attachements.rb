FactoryBot.define do
  factory :attachement do
    file File.open("#{Rails.root}/tmp/restart.txt")
  end
end
