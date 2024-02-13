FactoryBot.define do
  factory :registration do
    status { ['PENDING', 'CONFIRMED', 'CANCELED'].sample }
    user { FactoryBot.create(:user) }
    slot { FactoryBot.create(:slot) }
  end
end