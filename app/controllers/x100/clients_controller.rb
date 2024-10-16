# frozen_string_literal: true

module X100
  class ClientsController < ApplicationController
    before_action :authorize_request, only: %i[show update destroy]
    before_action :set_x100_client, only: %i[show update destroy]

    # GET /x100/clients
    def index
      @x100_clients = X100::Client.find_by(phone: fetch_user[:phone])

      if @x100_clients.nil?
        render json: { message: "Client with phone: #{fetch_user[:phone]} doesn't exist" }, status: :not_found
      else
        render json: @x100_clients, status: :ok
      end
    end

    # GET /x100/clients/dni
    def dni
      @x100_clients = X100::Client.find_by(dni: fetch_user[:dni])

      if fetch_user[:dni].nil?
        render json: { message: 'You must provide a dni' }, status: :bad_request
      else
        if @x100_clients.nil?
          render json: { message: "Client with phone: #{fetch_user[:dni]} doesn't exist" }, status: :not_found
        else
          render json: @x100_clients, status: :ok
        end
      end
    end

    # GET /x100/clients/1
    def show
      if admin?
        render json: @x100_client, status: :ok
      else
        render json: { message: 'You are not authorized to perform this action' }, status: :unauthorized
      end
    end

    # POST /x100/clients
    def create
      @x100_client = X100::Client.new(x100_client_params)

      
      if @x100_client.phone_belongs_to_user.nil?
        if @x100_client.save
          render json: @x100_client, status: :created, location: @x100_client
        else
          render json: @x100_client.errors, status: :unprocessable_entity
        end
      else
        render json: { message: 'Client already exists', user: @x100_client.phone_belongs_to_user }, status: :ok
      end
    end
    
    def integrator
      @x100_client = X100::Client.new(x100_integrator_params)
      @existant_user = X100::Client.find_by(x100_integrator_params)

      if @existant_user
        render json: { message: 'Client already exists', user: @existant_user }, status: :ok
      else
        if @x100_client.save
          render json: @x100_client, status: :created, location: @x100_client
        else
          render json: @x100_client.errors, status: :unprocessable_entity
        end
      end
    end

    # PATCH/PUT /x100/clients/1
    def update
      if admin?
        if @x100_client.update(x100_client_params)
          render json: @x100_client
        else
          render json: @x100_client.errors, status: :unprocessable_entity
        end
      else
        render json: { message: 'You are not authorized to perform this action' }, status: :unauthorized
      end
    end

    # DELETE /x100/clients/1
    def destroy
      if admin?
        if @x100_client.destroy
          render json: { message: 'Client was successfully deleted', user: @x100_client }, status: :ok
        else
          render json: @x100_client.errors, status: :unprocessable_entity
        end
      else
        render json: { message: 'You are not authorized to perform this action' }, status: :unauthorized
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_x100_client
      @x100_client = X100::Client.find(params[:id])
    end

    def admin?
      @current_user.role == 'Admin'
    end

    def fetch_user
      params.permit(:phone, :dni)
    end

    # Only allow a list of trusted parameters through.
    def x100_client_params
      params.require(:x100_client).permit(:name, :dni, :phone, :email, :pv)
    end

    def x100_integrator_params
      params.require(:x100_client).permit(:name, :email, :username, :integrator_type, :integrator_id)
    end
  end
end
