class RegistrationsController < ApplicationController
    def index
        @registrations = Registration.where(search_params)
        if @registrations.empty?
            render json: { error: "No registrations found" }, status: :not_found
        else
            paginate(@registrations)
        end
    end

    def show
        @registrations = Registration.find(params[:id])
        if @registrations.nil?
            render json: { error: "Invalid registration ID" }, status: :not_found
        else
            render json: @registrations, status: :ok
        end
    end

    def new
        @registration = Registration.new
    end

    def create
        @event = Event.find_by(id: params[:event_id])
        if @event.nil? || @event.event_status != "AVAILABLE"
            render json: { error: "Invalid event ID or event is not available for registration" }, status: :forbidden
        else
            @slot = @event.slots.find_by(id: params[:slot_id])
            if @slot.nil? || @slot.status != "AVAILABLE"
                render json: { error: "Invalid slot ID or slot is not available for registration" }, status: :forbidden
            else
                @slot.status = "BOOKED"
                if @slot.save
                    @registration = Registration.new(status: "PENDING", slot_id: @slot.id, user_id: current_user.id)
                    if @registration.save
                        # check payment status and update registration status
                        render json: @registration, status: :ok
                    else
                        render json: { errors: @registration.errors.full_messages }, status: :unprocessable_entity
                    end
                else
                    render json: { errors: @slot.errors.full_messages }, status: :unprocessable_entity
                end
            end
        end
    end


    def destroy
        @registration = Registration.find(params[:id])
        if @registration.nil? || @registration.user_id != current_user.id
            render json: { error: "Invalid registration ID or you do not have permission to delete this registration" }, status: :forbidden
        elsif @registration.payment.nil? || @registration.payment.status != 'FAILED'
            render json: { error: "Registration cannot be deleted unless its payment status is cancelled" }, status: :unprocessable_entity
        else
            @slot = @registration.slot
            @slot.status = "AVAILABLE"
            if @slot.save
                @registration.destroy
                render json: { message: "Registration deleted successfully" }, status: :ok
            else
                render json: { errors: @slot.errors.full_messages }, status: :unprocessable_entity
            end
        end
    end

    private 

    def registration_params
        params.require(:registration).permit(:slot_id, :status, :payment_id, :receipt_url)
    end

    def search_params
        params.permit( :id , :user_id, :slot_id , :status , :payment_id)
    end

    def paginate(record)
        begin
            @pagy, @records = pagy(record , items: 2)
            render json: @records , each_serializer: RegistrationSerializer , status: :ok
        rescue Pagy::OverflowError => e
            render json: { error: e.message }, status: :bad_request
        end
    end

end