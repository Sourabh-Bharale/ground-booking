class UsersController < ApplicationController
    skip_before_action :authorized, only: [:create]
    rescue_from ActiveRecord::RecordInvalid, with: :handle_invalid_record

    def create
        role_type = user_params[:role_type].presence || 'USER'
        role = AccessRole.find_by(role: role_type)
        return render json: { error: 'Invalid role_type' }, status: :bad_request unless role

        user = User.create!(user_params.except(:role_type).merge(access_role_id: role.id))
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
        params.require(:user).permit(:mobile_no, :password , :user_name , :role_type)
    end

    def handle_invalid_record(e)
        render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
    end
end
