class SlotsController < ApplicationController
    def index
        @slots = Event.find(params[:event_id]).slots.all
        render json: @slots, status: :ok
    end

    def show
        @slot = Slot.find(params[:id])
        if @slot.nil?
            render json: { error: "Invalid slot ID" }, status: :not_found
        else
            render json: @slot, status: :ok
        end
    end

    def new
        @slot = Slot.new
    end

    def create
            @event = Event.find(params[:event_id])
            @slot = @event.slots.new(slot_params)
            authorize! :create, @slot
            if @event.nil? || @event.user_id != current_user.id
                render json: { error: "Invalid event ID or you do not have permission to add a slot to this event user id allowed #{@event.user_id} but received #{current_user.id}" }, status: :forbidden
            elsif @event.event_status != "AVAILABLE"
                render json: { error: "Event is not available for slot update" }, status: :forbidden
            else
                if @slot.save
                    render json: @slot, status: :created
                else
                    render json: { errors: @slot.errors.full_messages }, status: :unprocessable_entity
                end
            end
    end

    def edit
        @slot = Slot.find(params[:id])
    end

    def update
        @event = Event.find(params[:event_id])
        @slot = Slot.find(params[:id])
        authorize! :update, @slot
        if @event.nil? || @event.user_id != current_user.id
            render json: { error: "Invalid event ID or you do not have permission to update a slot to this event user id allowed #{@event.user_id} but received #{current_user.id}" }, status: :forbidden
        elsif @event.event_status != "AVAILABLE"
            render json: { error: "Event is not available for slot update" }, status: :forbidden
        else
            if @slot.update(slot_params)
                render json: @slot, status: :ok
            else
                render json: { errors: @slot.errors.full_messages }, status: :unprocessable_entity
            end
        end
    end

    def destroy
        @event = Event.find(params[:event_id])
        @slot = Slot.find(params[:id])
        authorize! :destroy, @slot
        if @event.nil? || @event.user_id != current_user.id
            render json: { error: "Invalid event ID or you do not have permission to delete a slot to this event user id allowed #{@event.user_id} but received #{current_user.id}" }, status: :forbidden
        else
            @slot.destroy
            render json: { message: "Slot deleted successfully" }, status: :ok
        end
    end

    

   private

    def slot_params
        params.require(:slot).permit(:time_slot, :status)
    end
end