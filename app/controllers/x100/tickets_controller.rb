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

    def sell_tickets
      
    end

    private

    def fetch_tickets
      params.permit(:raffle_id, :current_page, :items_per_page)
    end
  end
end
