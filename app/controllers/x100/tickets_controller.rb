# frozen_string_literal: true

require 'pagy/extras/array'

module X100
  class TicketsController < ApplicationController
    before_action :authorize_request, only: %i[sell_tickets]
    before_action :fetch_tickets, only: %i[index]
    
    include Pagy::Backend

    def index
      @tickets = X100::Ticket.all_sold_tickets

      render json: @tickets, status: :ok
    end

    def show
      @x100_ticket = X100::Ticket.sold_tickets(params[:id])[0]

      if @x100_ticket == nil
        render json: { message: "Raffle with ID: #{params[:id]} not found" }, status: :not_found
      else
        render json: @x100_ticket, status: :ok
      end
    end

    def create
      @x100_ticket = X100::Ticket.new(create_x100_ticket_params)
      @x100_raffle = @x100_ticket.x100_raffle
      @x100_client = @x100_ticket.x100_client

      if @x100_ticket.save
        @tickets = X100::Ticket.all_sold_tickets

        @x100_order = X100::Order.new()

        ActionCable.server.broadcast('x100_tickets', @tickets)
        render json: @x100_ticket, status: :created, location: @x100_ticket
      else
        render json: @x100_ticket.errors, status: :unprocessable_entity
      end
    end

    private

    def create_x100_ticket_params
      params.permit(:x100_raffle_id, :x100_client_id, positions: [])
    end

    def x100_order_params
      params.require(:x100_order).permit(:products, :amount, :serial, :ordered_at, :shared_user_id, :x100_client_id)
    end

    def fetch_tickets
      params.permit(:raffle_id, :current_page, :items_per_page)
    end
  end
end
