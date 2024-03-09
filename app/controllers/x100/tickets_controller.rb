# frozen_string_literal: true

module X100
  class TicketsController < ApplicationController
    before_action :authorize_request, except: [:refresh]
    before_action :fetch_tickets, only: [:index]

    def index
      @tickets = X100::Ticket.all_sold_tickets

      render json: @tickets, status: :ok
    end

    def show
      @x100_ticket = X100::Ticket.sold_tickets(params[:id]).first

      if @x100_ticket.nil?
        render json: { message: "Raffle with ID: #{params[:id]} not found" }, status: :not_found
      else
        render json: @x100_ticket, status: :ok
      end
    end

    def sell
      positions = sell_x100_ticket_params[:positions]
      success_sold = []

      if positions.blank?
        parameter_require_error
      else
        begin
          ActiveRecord::Base.transaction do
            # -- validates_integration_of_tickets(positions) -- #
            positions.each do |position|
              @x100_ticket = find_reserved_ticket(position)

              if @x100_ticket.nil?
                render_ticket_not_sold(position)
                return
              else
                success_sold << @x100_ticket.position
              end
            end
            # -- validates_integration_of_tickets(positions) -- #
            
            if success_sold.length == positions.length
              if !sell_x100_ticket_params[:integrator].nil?
                if sell_x100_ticket_params[:player_id].nil?
                  raise ActiveRecord::Rollback, 'Failed to sell ticket'
                end
                @orders = X100::Order.new(
                  products: success_sold.map(&:position),
                  amount: sell_x100_ticket_params[:price],
                  serial: "ORD-#{SecureRandom.hex(8).upcase}",
                  ordered_at: DateTime.now,
                  money: sell_x100_ticket_params[:money],
                  shared_user_id: @current_user.id,
                  x100_client_id: X100::Client.find_by(integrator_id: sell_x100_ticket_params[:x100_client_id], integrator_type: sell_x100_ticket_params[:integrator]).id,
                  x100_raffle_id: sell_x100_ticket_params[:x100_raffle_id],
                  integrator_player_id: sell_x100_ticket_params[:player_id],
                  integrator: sell_x100_ticket_params[:integrator],
                  shared_exchange_id: Shared::Exchange.last.id
                )

                if @orders.integrator_job == false
                  raise ActiveRecord::Rollback, 'Failed to sell ticket'
                else
                  X100::Ticket.where(position: success_sold, x100_raffle_id: sell_x100_ticket_params[:x100_raffle_id]).update_all(
                    price: X100::Raffle.find(@x100_ticket.x100_raffle_id).price_unit,
                    money: ticket_params[:money],
                    status: 'sold',
                    x100_raffle_id: ticket_params[:x100_raffle_id],
                    x100_client_id: sell_x100_ticket_params[:integrator].nil? ? ticket_params[:x100_client_id] : X100::Client.find_by(integrator_id: sell_x100_ticket_params[:x100_client_id], integrator_type: sell_x100_ticket_params[:integrator]).id
                  )
                  @orders.save!

                  # -- live_transactions -- #
                  @tickets = X100::Ticket.all_sold_tickets
                  @raffles = X100::Raffle.current_progress_of_actives

                  ActionCable.server.broadcast('x100_raffles', @raffles)
                  ActionCable.server.broadcast('x100_tickets', @tickets)
                  # -- live_transactions -- #
                end
              else
                X100::Ticket.where(position: success_sold, x100_raffle_id: sell_x100_ticket_params[:x100_raffle_id]).update_all(
                  price: X100::Raffle.find(@x100_ticket.x100_raffle_id).price_unit,
                  money: ticket_params[:money],
                  status: 'sold',
                  x100_raffle_id: ticket_params[:x100_raffle_id],
                  x100_client_id: sell_x100_ticket_params[:integrator].nil? ? ticket_params[:x100_client_id] : X100::Client.find_by(integrator_id: sell_x100_ticket_params[:x100_client_id], integrator_type: sell_x100_ticket_params[:integrator]).id
                )
                @orders.save!

                # -- live_transactions -- #
                @tickets = X100::Ticket.all_sold_tickets
                @raffles = X100::Raffle.current_progress_of_actives

                ActionCable.server.broadcast('x100_raffles', @raffles)
                ActionCable.server.broadcast('x100_tickets', @tickets)
                # -- live_transactions -- #
                @orders = X100::Order.create!(
                  products: success_sold.map(&:position),
                  amount: sell_x100_ticket_params[:price],
                  serial: "ORD-#{SecureRandom.hex(8).upcase}",
                  ordered_at: DateTime.now,
                  money: sell_x100_ticket_params[:money],
                  shared_user_id: @current_user.id,
                  x100_client_id: sell_x100_ticket_params[:x100_client_id],
                  x100_raffle_id: sell_x100_ticket_params[:x100_raffle_id],
                  shared_exchange_id: Shared::Exchange.last.id
                )
              end
              render json: { message: 'Tickets sold', tickets: success_sold, order: @orders.serial }, status: :ok
            else
              render json: { message: "Oops! An error has occurred: #{success_sold.length} of #{positions.length} tickets sold" },
                    status: :unprocessable_entity
            end
          rescue => e 
            # -- live_transactions -- #
            @tickets = X100::Ticket.all_sold_tickets
            @raffles = X100::Raffle.current_progress_of_actives

            ActionCable.server.broadcast('x100_raffles', @raffles)
            ActionCable.server.broadcast('x100_tickets', @tickets)
            # -- live_transactions -- #

            render json: { message: "Oops! An error has occurred", error: e.message }, status: :unprocessable_entity
          end
        end
      end
    end

    def refresh
      @tickets = X100::Ticket.all_sold_tickets
      @raffles = X100::Raffle.current_progress_of_actives

      ActionCable.server.broadcast('x100_raffles', @raffles)
      ActionCable.server.broadcast('x100_tickets', @tickets)

      render json: { message: 'Ok!' }, status: :ok
    end

    def apart
      @x100_ticket = X100::Ticket.find_by(find_raffles_by_params)

      if @x100_ticket.nil?
        render_not_found("Ticket with position: #{find_raffles_by_params[:position]} can't be apart")
      elsif @x100_ticket.available?
        return raffle_is_closed_error if @x100_ticket.status == 'Cerrada'
        X100::Ticket.apart_ticket(@x100_ticket.id)
        @tickets = X100::Ticket.all_sold_tickets
        @raffles = X100::Raffle.current_progress_of_actives

        ActionCable.server.broadcast('x100_raffles', @raffles)
        ActionCable.server.broadcast('x100_tickets', @tickets)
        render json: { message: 'Ticket aparted', ticket: @x100_ticket }, status: :ok
      else
        render json: { message: "Ticket with position: #{find_raffles_by_params[:position]} can't be apart" },
               status: :unprocessable_entity
      end
    end

    def available
      @x100_ticket = X100::Ticket.find_by(find_raffles_by_params)

      if @x100_ticket.nil?
        render_not_found("Ticket with position: #{find_raffles_by_params[:position]} can't be apart")
      elsif @x100_ticket.reserved?
        return raffle_is_closed_error if @x100_ticket.status == 'Cerrada'
        X100::Ticket.find(@x100_ticket.id).turn_available!
        @tickets = X100::Ticket.all_sold_tickets
        @raffles = X100::Raffle.current_progress_of_actives
        @x100_ticket.status = 'available'

        ActionCable.server.broadcast('x100_raffles', @raffles)
        ActionCable.server.broadcast('x100_tickets', @tickets)
        render json: { message: 'Ticket returns to available', ticket: @x100_ticket }, status: :ok
      else
        render json: { message: "Ticket with position: #{find_raffles_by_params[:position]} can't be available" },
               status: :unprocessable_entity
      end
    end

    private

    def find_reserved_ticket(position)
      X100::Ticket.find_by(x100_raffle_id: sell_x100_ticket_params[:x100_raffle_id], position: position,
                           status: 'reserved')
    end

    def render_ticket_not_sold(position)
      render json: { message: "Ticket with position: #{position} can't be sold" }, status: :unprocessable_entity
    end

    def ticket_params
      sell_x100_ticket_params.slice(:x100_client_id, :x100_raffle_id, :price, :money)
    end

    def find_raffles_by_params
      params.require(:x100_ticket).permit(:x100_raffle_id, :position)
    end

    def render_not_found(message)
      render json: { message: }, status: :not_found
    end

    def sell_x100_ticket_params
      params.require(:x100_ticket).permit(:x100_raffle_id, :x100_client_id, :price, :money, :integrator, :player_id, positions: [])
    end

    def parameter_require_error
      render json: { message: 'Oops! An error has been occurred: Parameter(s) is required' },
             status: :unprocessable_entity
    end

    def raffle_is_closed_error
      render json: { message: 'Raffle is closed, try with other raffle' }, status: :forbidden
    end

    def fetch_tickets
      params.require(:raffle_id, :current_page, :items_per_page)
    end
  end
end
