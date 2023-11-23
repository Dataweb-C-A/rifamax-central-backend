class Fifty::LocationsController < ApplicationController
  before_action :set_fifty_location, only: %i[ show update destroy ]

  # GET /fifty/locations
  def index
    @fifty_locations = Fifty::Location.all

    render json: @fifty_locations
  end

  # GET /fifty/locations/1
  def show
    render json: @fifty_location
  end

  # POST /fifty/locations
  def create
    @fifty_location = Fifty::Location.new(fifty_location_params)

    if @fifty_location.save
      render json: @fifty_location, status: :created, location: @fifty_location
    else
      render json: @fifty_location.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /fifty/locations/1
  def update
    if @fifty_location.update(fifty_location_params)
      render json: @fifty_location
    else
      render json: @fifty_location.errors, status: :unprocessable_entity
    end
  end

  # DELETE /fifty/locations/1
  def destroy
    @fifty_location.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fifty_location
      @fifty_location = Fifty::Location.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def fifty_location_params
      params.require(:fifty_location).permit(:country, :state)
    end
end
