class AuthController < ApplicationController
    skip_before_action :authorized, only: [:login]
    rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found

    def login 
        @user = User.find_by(mobile_no: login_params[:mobile_no])
        if @user
            if @user.authenticate(login_params[:password])
                @token = encode_token(user_id: @user.id)
                render json: {
                    user: UserSerializer.new(@user),
                    token: @token
                }, status: :accepted
            else
                render json: {error: "Invalid mobile number or password"}, status: :unauthorized
            end
        else
            render json: {error: "Invalid mobile number or password"}, status: :unauthorized
        end
    end

    private 

    def login_params 
        params.require(:user).permit(:mobile_no, :password)
    end

    def handle_record_not_found(e)
        render json: { error: e.record.errors.full_messages}, status: :unauthorized
    end

end
