class RegistrationsController < ApplicationController
    before_action :set_registration, only: [:show, :destroy]
    before_action :set_event_and_slot, only: [:create]

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

    def create
        unless valid_event_and_slot?
            render json: { error: "Invalid event ID or slot ID" }, status: :forbidden
            return
        end
        if @slot.status == "BOOKED"
            render json: { error: "Slot is already booked" }, status: :conflict
            return
        end
        @slot.update!(status: "BOOKED")
        @registration = Registration.new(status: "PENDING", slot: @slot, user: current_user)
        if @registration.save
            render json: @registration, status: :created
        else
            render json: { errors: @registration.errors.full_messages }, status: :unprocessable_entity
        end
    end


    def destroy
        unless valid_registration?
            render json: { error: "Invalid registration ID or you do not have permission to delete this registration" }, status: :forbidden
        end

        unless valid_payment?
            render json: { error: "Payment already exists for this registration" }, status: :forbidden
        end

        @registration.slot.update!(status: "AVAILABLE")
        @registration.destroy
        render json: { message: "Registration deleted successfully" }, status: :ok
    end

    private

        def set_registration
            @registration = Registration.find(params[:id])
        end

        def set_event_and_slot
            @event = Event.find_by(id: params[:event_id])
            @slot = @event&.slots&.find_by(id: params[:slot_id])
        end

        def valid_event_and_slot?
            @event.present? && @event.event_status == "AVAILABLE" && @slot.present? && @slot.status == "AVAILABLE"
        end

        def valid_registration?
            @registration.present? && @registration.user_id == current_user.id
        end

        def valid_payment?
            @registration.payment.nil? || @registration.payment.status == 'FAILED'
        end

        def registration_params
            params.require(:registration).permit(:slot_id, :status, :payment_id, :receipt_url)
        end

        def search_params
            params.permit( :id , :user_id, :slot_id , :status , :payment_id)
        end

        def paginate(record)
            begin
                @pagy, @records = pagy(record , items: 10)
                render json: {
                    registrations: @records,
                    total_pages: @pagy.pages,
                    total_records: @pagy.count
                    } , each_serializer: RegistrationSerializer , status: :ok
            rescue Pagy::OverflowError => e
                render json: { error: e.message }, status: :bad_request
            end
        end

end