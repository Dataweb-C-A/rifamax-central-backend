class Shared::ExchangesController < ApplicationController
  before_action :authorize_request, except: %i[index]
  before_action :set_shared_exchange, only: %i[ show update destroy ]

  # GET /shared/exchanges
  def index
    @shared_exchanges = Shared::Exchange.all

    render json: @shared_exchanges
  end

  # GET /shared/exchanges/1
  def show
    render json: @shared_exchange
  end

  # POST /shared/exchanges
  def create
    if @current_user.role == 'Admin'
      @shared_exchange = Shared::Exchange.new(shared_exchange_params)
  
      if @shared_exchange.save
        render json: @shared_exchange, status: :created, location: @shared_exchange
      else
        render json: @shared_exchange.errors, status: :unprocessable_entity
      end
    else
      render json: { message: "Unauthorized" }, status: :unauthorized
    end
  end

  # PATCH/PUT /shared/exchanges/1
  def update
    if @current_user.role == 'Admin'
      if @shared_exchange.update(shared_exchange_params)
        render json: @shared_exchange
      else
        render json: @shared_exchange.errors, status: :unprocessable_entity
      end
    else
      render json: { message: "Unauthorized" }, status: :unauthorized
    end
  end

  # DELETE /shared/exchanges/1
  def destroy
    if @current_user.role == 'Admin'
      if @shared_exchange.destroy
        render json: { message: "Exchange deleted" }, status: :ok
      else
        render json: @shared_exchange.errors, status: :unprocessable_entity
      end
    else
      render json: { message: "Unauthorized" }, status: :unauthorized
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shared_exchange
      @shared_exchange = Shared::Exchange.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def shared_exchange_params
      params.require(:shared_exchange).permit(:value_bs, :value_cop, :mainstream_money, :automatic)
    end
end
