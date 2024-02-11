class PaymentsController < ApplicationController

    def index
        @payment = Registration.find(params[:registration_id]).payment
        render json: @payment, status: :ok
    end
    
    def create
        @registration = Registration.find(params[:registration_id])
        if invalid_registration?
            render json: { error: "Invalid registration ID or you do not have permission to make payment for this registration" }, status: :forbidden
        elsif registration_booked?
            render json: { error: "This registration is not available for payment" }, status: :forbidden
        elsif @registration.payment.present?
            render json: { error: "Payment already exists for this registration" }, status: :forbidden
        else
            process_payment
        end
    end

    def update
        @payment = Payment.find(params[:id])
        @registration = @payment.registration

        if invalid_payment?
            render json: { error: "Invalid payment ID or you do not have permission to update this payment" }, status: :forbidden
        elsif @payment.status == "PAID"
            render json: { error: "payment with status PAID, cannot be updated" }, status: :forbidden
        else
            process_payment_update
        end
    end

    def destroy
        @payment = Payment.find(params[:id])
        @registration = @payment.registration

        if invalid_payment?
            render json: { error: "Invalid payment ID or you do not have permission to delete this payment" }, status: :forbidden
        elsif @payment.status == "PAID"
            render json: { error: "payment with status PAID, cannot be deleted" }, status: :forbidden
        else
            process_payment_deletion
        end
    end

    private

    def invalid_payment?
        @payment.nil? || @payment.user_id != current_user.id
    end

    def process_payment_update
        if @payment.update(update_params)
            update_registration_and_slot_status
            render json: @payment, status: :ok
        else
            render json: { errors: @payment.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def process_payment_deletion
        @registration.update(payment_id: nil)
        @payment.destroy
        render json: { message: "Payment deleted successfully" }, status: :ok
    end

    def invalid_registration?
        @registration.nil? || @registration.user_id != current_user.id
    end

    def registration_booked?
        @registration.status == "BOOKED"
    end

    def process_payment
        @payment = @registration.build_payment(payment_params)
        if @payment.save
            if @payment.status == "PAID"
                @registration.update(payment_id: @payment.id, receipt_url: "https://www.example.com/receipts/#{SecureRandom.uuid}")
            else
                @registration.update(payment_id: @payment.id)
            end
            update_registration_and_slot_status
            render json: @payment, status: :created
        else
            render json: { errors: @payment.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def update_registration_and_slot_status
        if @payment.status == "PAID"
            @registration.status = "CONFIRMED"
            @registration.receipt_url = "https://www.example.com/receipts/#{SecureRandom.uuid}"
            @registration.slot.status = "BOOKED"
        elsif @payment.status == "PENDING"
            @registration.status = "PENDING"
            @registration.slot.status = "AVAILABLE"
        elsif @payment.status == "FAILED"
            @registration.status = "CANCELLED"
            @registration.slot.status = "AVAILABLE"
        end
        @registration.save
    end

    def payment_params 
        params.require(:payment).permit(:amount, :status).merge(user_id: current_user.id)
    end

    def update_params 
        params.require(:payment).permit(:status)
    end

end