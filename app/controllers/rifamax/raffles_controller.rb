# frozen_string_literal: true

module Rifamax
  class RafflesController < ApplicationController
    include Pagy::Backend

    before_action :set_rifamax_raffle, only: %i[show update destroy]
    before_action :authorize_request

    # GET /rifamax/raffles
    def index
      page = params[:page] || 1
      items = params[:items] || 7

      @pagy, @records = pagy(
        Rifamax::Raffle.active_today(@current_user.id), 
        page: page, 
        items: items
      )

      render json: { 
        raffles: serialize(@records), 
        metadata: {
          count: @pagy.count,
          page: @pagy.page,
          items: @pagy.items,
          pages: @pagy.pages
        }
      }
    end

    # GET /rifamax/raffles/newest
    def newest
      page = params[:page] || 1
      items = params[:items] || 7

      @pagy, @records = pagy(
        Rifamax::Raffle.filter_by_status(@current_user.id, 'newest'), 
        page: page, 
        items: items
      )

      render json: { 
        raffles: serialize(@records), 
        metadata: {
          count: @pagy.count,
          page: @pagy.page,
          items: @pagy.items,
          pages: @pagy.pages
        }
      }
    end

    # GET /rifamax/raffles/initialized
    def initialized
      page = params[:page] || 1
      items = params[:items] || 7

      @pagy, @records = pagy(
        Rifamax::Raffle.filter_by_status(@current_user.id, 'initialized'), 
        page: page, 
        items: items
      )

      render json: { 
        raffles: serialize(@records), 
        metadata: {
          count: @pagy.count,
          page: @pagy.page,
          items: @pagy.items,
          pages: @pagy.pages
        }
      }
    end

    # GET /rifamax/raffles/to_close
    def to_close
      page = params[:page] || 1
      items = params[:items] || 7

      @pagy, @records = pagy(
        Rifamax::Raffle.need_to_close(@current_user.id), 
        page: page, 
        items: items
      )

      render json: { 
        raffles: serialize(@records), 
        metadata: {
          count: @pagy.count,
          page: @pagy.page,
          items: @pagy.items,
          pages: @pagy.pages
        }
      }
    end

    # POST /rifamax/raffles/send_app
    def send_app
      @rifamax_raffle = Rifamax::Raffle.find(params[:raffle_id])
      if @rifamax_raffle.sent!
        @rifamax_raffle.update(expired_date: Date.today + 3.days)
        render json: @rifamax_raffle
      else
        render json: @rifamax_raffle.errors, status: :unprocessable_entity
      end
    end

    # POST /rifamax/raffles/print
    def print
      @rifamax_raffle = Rifamax::Raffle.find(params[:raffle_id])
      if @rifamax_raffle.sold!
        render json: @rifamax_raffle
      else
        render json: @rifamax_raffle.errors, status: :unprocessable_entity
      end
    end

    # POST /rifamax/raffles/print
    def sell
      @rifamax_raffle = Rifamax::Raffle.find(params[:raffle_id])
      if @rifamax_raffle.sold!
        render json: @rifamax_raffle
      else
        render json: @rifamax_raffle.errors, status: :unprocessable_entity
      end
    end

    # POST /rifamax/raffles/pay
    def pay
      @rifamax_raffle = Rifamax::Raffle.find(params[:raffle_id])
      if @rifamax_raffle.admin_status == 0
        @rifamax_raffle.update(admin_status: 1)
        render json: @rifamax_raffle
      else
        render json: { message: "Can't move status" }, status: :unprocessable_entity
      end
    end

    # POST /rifamax/raffles/unpay
    def unpay
      @rifamax_raffle = Rifamax::Raffle.find(params[:raffle_id])
      if @rifamax_raffle.admin_status == 0
        @rifamax_raffle.update(admin_status: 2)
        render json: @rifamax_raffle
      else
        render json: { message: "Can't move status" }, status: :unprocessable_entity
      end
    end

    # POST /rifamax/raffles/refund
    def refund
      @rifamax_raffle = Rifamax::Raffle.find(params[:raffle_id])
      if @rifamax_raffle.admin_status == 0
        @rifamax_raffle.update(admin_status: 3)
        render json: @rifamax_raffle
      else
        render json: { message: "Can't move status" }, status: :unprocessable_entity
      end
    end

    # GET /rifamax/raffles/close_day
    def close_day
      @raffles = Rifamax::Raffle.where('expired_date <= ?', Date.today)

      @closed = @raffles.where(user_id: @current_user.id).where('admin_status > ?', 0)
      @unclosed = @raffles.where(user_id: @current_user.id, admin_status: 0)

      render json: {
        message: 'Fetched',
        closed: Rifamax::RaffleSerializer.new(@closed).object,
        unclosed: Rifamax::RaffleSerializer.new(@unclosed).object
      }
    end

    # GET /rifamax/raffles/close_day_info
    def close_day_info
      @raffles = Rifamax::Raffle.stats(Rifamax::Raffle.active.where(user_id: @current_user.id))

      render json @raffles, status: :ok
    end

    # GET /rifamax/raffles/1
    def show
      render json: @rifamax_raffle
    end

    # POST /rifamax/raffles
    def create
      @rifamax_raffle = Rifamax::Raffle.new(rifamax_raffle_params)
      @rifamax_raffle.user_id = @current_user.id
      
      if @rifamax_raffle.save
        render json: @rifamax_raffle, status: :created, location: @rifamax_raffle
      else
        render json: @rifamax_raffle.errors, status: :unprocessable_entity
      end
    end

    # POST /rifamax/raffles/seller_create
    def seller_create
      @rifamax_raffle = Rifamax::Raffle.new(rifamax_raffle_params)
      @rifamax_raffle.seller_id = @current_user.id

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
      if @rifamax_raffle.destroy
        render json: { message: 'Raffle has been deleted' }
      else
        render json: { message: 'Raffle has not been deleted' }
      end
    end

    private

    def serialize(raffles)
      ActiveModelSerializers::SerializableResource.new(raffles, each_serializer: Rifamax::RaffleSerializer)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_rifamax_raffle
      @rifamax_raffle = Rifamax::Raffle.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def rifamax_raffle_params
      params.require(:rifamax_raffle).permit(
        :title,
        :init_date,
        :price,
        :numbers,
        :currency,
        :lotery,
        :seller_id,
        :user_id,
        prizes: [:award, :plate, :year, :is_money, :wildcard]
      )
    end
  end
end
