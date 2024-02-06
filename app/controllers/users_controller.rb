class UsersController < ApplicationController
    skip_before_action :authorized, only: [:create]
    rescue_from ActiveRecord::RecordInvalid, with: :handle_invalid_record

    def create
        user = User.create!(user_params)
        @token = encode_token(user_id: user.id)
        render json:{
            user: UserSerializer.new(user),
            token: @token
        }, status: :created
    end
    
    def some_method
        render json: {message: "Only authorized users can see this message!"}
    end

    private

    def user_params
        params.require(:user).permit(:mobile_no, :password , :user_name)
    end

    def handle_invalid_record(e)
        render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
    end
end
