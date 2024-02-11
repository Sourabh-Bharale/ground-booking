FactoryBot.define do
  factory :user do
    user_name { "John" }
    mobile_no { "1234567890" }
    password { "password" }
    access_role { FactoryBot.create(:access_role) }
  end
end
