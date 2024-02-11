class ApplicationController < ActionController::Base
    protect_from_forgery 
    before_action :authorized
    include Pagy::Backend

    def encode_token(payload)
        JWT.encode(payload, Rails.application.secrets.secret_key_base)
    end
    
    def decoded_token
        header = request.headers['Authorization']
        if header 
            token = header.split(" ")[1]
            begin
                JWT.decode(token, Rails.application.secrets.secret_key_base, true, algorithm: 'HS256')
            rescue => exception
                nil
            end
        end
    end

    def current_user
        if decoded_token
            user_id = decoded_token[0]['user_id']
            @user = User.find_by(id: user_id)
        end
    end

    def authorized
        if current_user.nil?
            render json: {message: "Please log in"}, status: :unauthorized
        end
    end

 
  rescue_from CanCan::AccessDenied do |exception|
    render json: { error: exception.message }, status: :forbidden
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    Rails.logger.error "Record not found: #{exception.message}"
    render json: { error: 'Record not found' }, status: :not_found
  end

  rescue_from StandardError do |exception|
    Rails.logger.error "Error occurred: #{exception.message}"
    render json: { error: 'An error occurred' }, status: :internal_server_error
  end
end
