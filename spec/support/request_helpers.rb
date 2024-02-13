module RequestHelpers
    def add_headers(user)
        request.headers['Content-Type'] = 'application/json'
        request.headers['Authorization'] = user ? "Bearer #{JWT.encode({user_id: user.id}, Rails.application.secrets.secret_key_base)}" : ""
        request
    end

    def seed_data
        AccessRole.find_or_create_by(role: 'ADMIN')
        AccessRole.find_or_create_by(role: 'USER')
    end
end