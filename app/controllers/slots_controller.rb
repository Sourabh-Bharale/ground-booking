class SlotsController < ApplicationController
    before_action :set_event
    before_action :set_slot, only: [:show, :update, :destroy]
    before_action :check_event_validity
    before_action :check_event_availability, except: [:index, :show]

    def index
        @slots = @event.slots.all
        paginate(@slots)
    end

    def show
        if @slot.nil?
            render json: { error: "Invalid slot ID" }, status: :not_found
        else
            render json: @slot, status: :ok
        end
    end

    def create
        @slot = @event.slots.new(slot_params)
        authorize_slot
        if @slot.save
            render json: @slot, status: :created
        else
            render json: { errors: @slot.errors.full_messages }, status: :unprocessable_entity
        end
    end


    def update
        authorize_slot
        if @slot.update(slot_params)
            render json: @slot, status: :ok
        else
            render json: { errors: @slot.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def destroy
        authorize_slot
        if  @event.user_id != current_user.id
            render json: { error: "Invalid event ID or you do not have permission to delete a slot to this event user id allowed #{@event.user_id} but received #{current_user.id}" }, status: :forbidden
        else
            @slot.destroy
            render json: { message: "Slot deleted successfully" }, status: :ok
        end
    end

   private

   def authorize_slot
    authorize! :manage, @slot
   end

    def set_event
        @event = Event.find_by_id(params[:event_id])
        if @event.nil?
            render json: { error: "Invalid event ID" }, status: :not_found
        end
    end

    def set_slot
        @slot = Slot.find_by_id(params[:id])
        if @slot.nil?
            render json: { error: "Invalid slot ID" }, status: :not_found
        end
    end

    def check_event_validity
        if @event.nil? || @event.user_id != current_user.id
            render json: { error: "Invalid event ID or you do not have permission to add a slot to this event user id allowed #{@event.user_id} but received #{current_user.id}" }, status: :forbidden
            return
        end
    end

    def check_event_availability
        if @event.event_status != "AVAILABLE"
            render json: { error: "Event is not available for slot update" }, status: :forbidden
            return
        end
    end

    def paginate(record)
        begin
            @pagy, @records = pagy(record , items: 10)
            render json: {
                slots: @records,
                total_pages: @pagy.pages,
                total_records: @pagy.count
            }, status: :ok
        rescue Pagy::OverflowError => e
            render json: { error: e.message }, status: :bad_request
        end
    end

    def slot_params
        params.require(:slot).permit(:time_slot, :status)
    end

end