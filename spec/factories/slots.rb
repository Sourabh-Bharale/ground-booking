FactoryBot.define do
  factory :slot do
    sequence(:time_slot) { |n| "#{n%12+1}AM-#{n%12+2}AM" }
    status { ["AVAILABLE" , "BOOKED"].sample }
    event { FactoryBot.create(:event) }
  end
end