class AccessRole < ApplicationRecord
    enum role: {
        user: "USER",
        admin: "ADMIN",
    }
    has_many :users
    validates :role, presence: true
end
