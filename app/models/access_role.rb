class AccessRole < ApplicationRecord
    enum role: {
        user: "USER",
        admin: "ADMIN",
    }
end
