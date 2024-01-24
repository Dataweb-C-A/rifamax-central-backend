# frozen_string_literal: true

module X100
  class RafflesController < ApplicationController
    before_action :authorize_request
    before_action :set_x100_raffle, only: %i[show update destroy]

    # GET /x100/raffles
    def index
      @x100_raffles = X100::Raffle.raffles_by_user(@current_user)

      render json: @x100_raffles, status: :ok
    end

    # GET /x100/raffles/1
    def show
      if @x100_raffle_taquilla.nil?
        render json: { message: "Raffle with ID: #{params[:id]} not found" }, status: :not_found
      else
        render json: @x100_raffle_taquilla, status: :ok
      end
    end

    # POST /x100/raffles
    def create
      @x100_raffle = X100::Raffle.new(create_x100_raffle_params)
      @x100_raffle.shared_user_id = @current_user.id if @current_user.role == 'Taquilla'

      @x100_raffle.prize = [{ name: create_x100_raffle_params[:prizes], prize_position: 1 }]
      if @x100_raffle.save
        @raffles = X100::Raffle.current_progress_of_actives

        ActionCable.server.broadcast('x100_raffles', @raffles)
        render json: @x100_raffle, status: :created, location: @x100_raffle
      else
        render json: @x100_raffle.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /x100/raffles/1
    def update
      if @x100_raffle_taquilla.update(edit_x100_raffle_params)
        @raffles = X100::Raffle.current_progress_of_actives

        ActionCable.server.broadcast('x100_raffles', @raffles)
        render json: @x100_raffle_taquilla, status: :ok
      else
        puts @x100_raffle_taquilla.errors.full_messages
        render json: @x100_raffle_taquilla.errors.full_messages, status: :unprocessable_entity
      end
    end

    # DELETE /x100/raffles/1
    def destroy
      if @x100_raffle_taquilla.nil?
        @raffles = X100::Raffle.current_progress_of_actives

        ActionCable.server.broadcast('x100_raffles', @raffles)
        render json: { message: "Raffle with id: #{params[:id]} not found" }, status: :not_found
      else
        @x100_raffle_taquilla.destroy
        render json: { message: 'Raffle deleted', raffle: @x100_raffle_taquilla }, status: :ok,
               location: @x100_raffle_taquilla
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_x100_raffle
      @x100_raffle_taquilla = if @current_user.role == 'Admin'
                                X100::Raffle.find(params[:id])
                              else
                                X100::Raffle.where(id: params[:id], shared_user_id: @current_user.id).last
                              end
    end

    # Only allow a list of trusted parameters through.
    def edit_x100_raffle_params
      params.require(:x100_raffle).permit(
        :draw_type,
        :expired_date,
        :init_date,
        :money,
        :price_unit,
        :limit,
        :lotery,
        :numbers,
        :raffle_type,
        :title,
        :ad,
        prizes: %i[
          name prize_position
        ],
        combos: %i[
          price quantity
        ],
        automatic_taquillas_ids: []
      )
    end

    def create_x100_raffle_params
      params.require(:x100_raffle).permit(
        :ad,
        :draw_type,
        :expired_date,
        :init_date,
        :raffle_type,
        :limit,
        :lotery,
        :money,
        :price_unit,
        :tickets_count,
        :title,
        :shared_user_id,
        :numbers,
        :prizes,
        automatic_taquillas_ids: [],
        combos: %i[
          price quantity
        ]
      )
    end
  end
end
