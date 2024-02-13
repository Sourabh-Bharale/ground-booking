FactoryBot.define do
  factory :user do
    user_name { "John" }
    sequence(:mobile_no, 1000000000) { |n| n.to_s }
    password { "password" }
    access_role { FactoryBot.create(:access_role) }
  end
end
