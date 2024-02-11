FactoryBot.define do
  factory :registration do
    status { "PENDING" }
    association :user
    association :slot
  end
end