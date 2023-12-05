# frozen_string_literal: true

require 'pagy/extras/array'

class X100::TicketsController < ApplicationController
  include Pagy::Backend

  def index
    redis = Redis.new

    @initials = {
      raffle_id: fetch_tickets[:raffle_id] || "Not provided",
      current_page: fetch_tickets[:current_page] || 1,
      items_per_page: fetch_tickets[:items_per_page] || 100
    }

    @petition = redis.get("x100_raffle_tickets:#{@initials[:raffle_id]}")
    @x100_ticket = JSON.parse(@petition) if !@petition.nil? 
    
    if @x100_ticket.nil?
      render json: { message: "Raffle with ID: #{@initials[:raffle_id]} doesn't exist" }, status: :not_found
    else
      @pagy, @tickets = pagy_array(@x100_ticket, items: @initials[:items_per_page], page: @initials[:current_page])
      render json: { 
        metadata: {
          page: @pagy.page,
          count: @pagy.count,
          items: @pagy.items,
          pages: @pagy.pages
        },
        tickets: @tickets 
        }, status: :ok
    end
  end

  def sell; end

  private

  def fetch_tickets
    params.permit(:raffle_id, :current_page, :items_per_page)
  end
end
