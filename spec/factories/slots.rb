FactoryBot.define do
  factory :slot do
    time_slot { "9AM-10AM" }
    status { "AVAILABLE" }
    association :event
  end
end