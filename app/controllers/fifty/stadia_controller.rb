class Fifty::StadiaController < ApplicationController
  before_action :set_fifty_stadium, only: %i[ show update destroy ]

  # GET /fifty/stadia
  def index
    @fifty_stadia = Fifty::Stadium.all

    render json: @fifty_stadia
  end

  # GET /fifty/stadia/1
  def show
    render json: @fifty_stadium
  end

  # POST /fifty/stadia
  def create
    @fifty_stadium = Fifty::Stadium.new(fifty_stadium_params)

    if @fifty_stadium.save
      render json: @fifty_stadium, status: :created, location: @fifty_stadium
    else
      render json: @fifty_stadium.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /fifty/stadia/1
  def update
    if @fifty_stadium.update(fifty_stadium_params)
      render json: @fifty_stadium
    else
      render json: @fifty_stadium.errors, status: :unprocessable_entity
    end
  end

  # DELETE /fifty/stadia/1
  def destroy
    @fifty_stadium.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fifty_stadium
      @fifty_stadium = Fifty::Stadium.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def fifty_stadium_params
      params.require(:fifty_stadium).permit(:name, :location_id)
    end
end
