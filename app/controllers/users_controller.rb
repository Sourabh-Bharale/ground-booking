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


    def current_user_registrations
        @registrations = current_user.registrations.all
        paginate(@registrations)
    end

    def all_registrations
        if current_user.access_role.admin?
            @registrations = Registration.where(user_id: params[:user_id])
            paginate(@registrations)
        else
            render json: { error: "You do not have permission to view all registrations" }, status: :forbidden
        end
    end

    def search
        @users = User.where(search_params)
        if @users.empty?
            render json: { error: "No user found" }, status: :not_found
        else
           paginate(@users)
        end
    end

    private

    def paginate(record)
        begin
            @pagy, @records = pagy(record , items: 10)
            render json: {
                users: @records,
                total_pages: @pagy.pages,
                total_records: @pagy.count
                }, status: :ok
        rescue Pagy::OverflowError => e
            render json: { error: e.message }, status: :bad_request
        end
    end

    def search_params
        params.permit(:user_name, :mobile_no)
    end

    def user_params
        params.require(:user).permit(:mobile_no, :password , :user_name , :role_type)
    end

    def handle_invalid_record(e)
        render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
    end
end
