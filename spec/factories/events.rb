FactoryBot.define do
  factory :event do
    event_status { "AVAILABLE" }
    date { Date.today + 1.day }
    user { FactoryBot.create(:user) }
  end
end