FactoryBot.define do
  factory :access_role do
    role {[ "ADMIN", "USER" ].sample}
  end
end