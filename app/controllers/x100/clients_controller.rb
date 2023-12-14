# frozen_string_literal: true

module X100
  class ClientsController < ApplicationController
    before_action :authorize_request, only: %i[show update destroy]
    before_action :set_x100_client, only: %i[show update destroy]
    before_action :verify_user_admin, only: %i[show update destroy]

    # GET /x100/clients
    def index
      @x100_clients = X100::Client.find_by(phone: fetch_user[:phone])

      if @x100_clients.nil?
        render json: { message: "Client with phone: #{fetch_user[:phone]} doesn't exist" }, status: :not_found
      else
        render json: @x100_clients, status: :ok
      end
    end

    # GET /x100/clients/1
    def show
      render json: @x100_client, status: :ok
    end
    
    # POST /x100/clients
    def create
      @x100_client = X100::Client.new(x100_client_params)

      if @x100_client.save
        render json: @x100_client, status: :created, location: @x100_client
      else
        render json: @x100_client.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /x100/clients/1
    def update
      if @x100_client.update(x100_client_params)
        render json: @x100_client
      else
        render json: @x100_client.errors, status: :unprocessable_entity
      end
    end

    # DELETE /x100/clients/1
    def destroy
      @x100_client.destroy
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_x100_client
      @x100_client = X100::Client.find(params[:id])
    end

    def verify_user_admin 
      render json: { message: 'You are not authorized to perform this action' }, status: :unauthorized unless @current_user.Admin?
    end

    def fetch_user
      params.permit(:phone)
    end

    # Only allow a list of trusted parameters through.
    def x100_client_params
      params.require(:x100_client).permit(:name, :dni, :phone, :email)
    end
  end
end
