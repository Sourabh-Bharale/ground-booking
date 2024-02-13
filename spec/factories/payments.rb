FactoryBot.define do
  factory :payment do
    amount { 100.0 }
    status { "PENDING" }
    user { FactoryBot.create(:user) }
    registration { FactoryBot.create(:registration) }
  end
end