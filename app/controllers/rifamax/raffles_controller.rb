class Rifamax::RafflesController < ApplicationController
  before_action :set_rifamax_raffle, only: %i[ show update destroy ]

  # GET /rifamax/raffles
  def index
    @rifamax_raffles = Rifamax::Raffle.all

    render json: @rifamax_raffles
  end

  # GET /rifamax/raffles/1
  def show
    render json: @rifamax_raffle
  end

  # POST /rifamax/raffles
  def create
    @rifamax_raffle = Rifamax::Raffle.new(rifamax_raffle_params)

    if @rifamax_raffle.save
      render json: @rifamax_raffle, status: :created, location: @rifamax_raffle
    else
      render json: @rifamax_raffle.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /rifamax/raffles/1
  def update
    if @rifamax_raffle.update(rifamax_raffle_params)
      render json: @rifamax_raffle
    else
      render json: @rifamax_raffle.errors, status: :unprocessable_entity
    end
  end

  # DELETE /rifamax/raffles/1
  def destroy
    @rifamax_raffle.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rifamax_raffle
      @rifamax_raffle = Rifamax::Raffle.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def rifamax_raffle_params
      params.require(:rifamax_raffle).permit(:init_date, :award_sign, :award_no_sign, :plate, :year, :price, :loteria, :numbers, :serial, :expired_date, :is_send, :is_closed, :refund, :rifero_id)
    end
end