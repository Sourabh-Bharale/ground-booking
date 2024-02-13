class EventsController < ApplicationController
  load_and_authorize_resource

  def index
    @events = Event.where(search_params)
    if @events.empty?
      render json: { error: "No Events found" }, status: :not_found
    else
      paginate(@events)
    end
  end

  def show
    @event = Event.find(params[:id])
    render json: @event, status: :ok
  end

  def create
    @event = current_user.events.new(event_params)
    authorize! :create, @event
    if @event.save
        render json: @event, status: :created
    else
        render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @event = current_user.events.find(params[:id])
    authorize! :update, @event
    if @event.update(event_params)
      render json: @event, status: :ok
    else
      render json: { errors: @event.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @event = current_user.events.find(params[:id])
    authorize! :destroy, @event
    begin
      @event.destroy
        render json: { message: "Event deleted successfully" }, status: :ok
    rescue ActiveRecord::InvalidForeignKey => e
      render json: { errors: "cannot delete event while slots exists" }, status: :unprocessable_entity
    end
  end

  private

  def paginate(record)
    begin
      @pagy, @records = pagy(record , items: 2)
      render json: { events: @records }, status: :ok
    rescue Pagy::OverflowError => e
      render json: { error: e.message }, status: :bad_request
    end
  end

  def event_params
    params.require(:event).permit(:event_status, :date)
  end

  def search_params
    params.permit(:event_status, :date)
  end
  
end
