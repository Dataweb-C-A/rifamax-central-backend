class X100::OrdersController < ApplicationController
  before_action :authorize_request
  before_action :set_x100_order, only: %i[ show update destroy ]

  # GET /x100/orders
  def index
    @x100_orders = X100::Order.all

    render json: @x100_orders
  end

  # GET /x100/orders/1
  def show
    render json: @x100_order
  end

  # POST /x100/orders
  def create
    @x100_order = X100::Order.new(x100_order_params)

    if @x100_order.save
      render json: @x100_order, status: :created, location: @x100_order
    else
      render json: @x100_order.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /x100/orders/1
  def update
    if @x100_order.update(x100_order_params)
      render json: @x100_order
    else
      render json: @x100_order.errors, status: :unprocessable_entity
    end
  end

  # DELETE /x100/orders/1
  def destroy
    @x100_order.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_x100_order
      @x100_order = X100::Order.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def x100_order_params
      params.require(:x100_order).permit(:products, :amount, :serial, :ordered_at, :shared_user_id, :x100_client_id)
    end
end
