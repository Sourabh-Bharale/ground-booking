FactoryBot.define do
  factory :payment do
    amount { 100.0 }
    status { "PENDING" }
    association :user
    association :registration
  end
end