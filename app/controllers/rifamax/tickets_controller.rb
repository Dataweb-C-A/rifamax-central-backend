class Rifamax::TicketsController < ApplicationController
  before_action :set_rifamax_ticket, only: %i[ show update destroy ]

  # GET /rifamax/tickets
  def index
    @rifamax_tickets = Rifamax::Ticket.all

    render json: @rifamax_tickets
  end

  # GET /rifamax/tickets/1
  def show
    render json: @rifamax_ticket
  end

  # POST /rifamax/tickets
  def create
    @rifamax_ticket = Rifamax::Ticket.new(rifamax_ticket_params)

    if @rifamax_ticket.save
      render json: @rifamax_ticket, status: :created, location: @rifamax_ticket
    else
      render json: @rifamax_ticket.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /rifamax/tickets/1
  def update
    if @rifamax_ticket.update(rifamax_ticket_params)
      render json: @rifamax_ticket
    else
      render json: @rifamax_ticket.errors, status: :unprocessable_entity
    end
  end

  # DELETE /rifamax/tickets/1
  def destroy
    @rifamax_ticket.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rifamax_ticket
      @rifamax_ticket = Rifamax::Ticket.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def rifamax_ticket_params
      params.require(:rifamax_ticket).permit(:sign, :number, :ticket_nro, :serial, :is_sold, :raffle_id)
    end
end
