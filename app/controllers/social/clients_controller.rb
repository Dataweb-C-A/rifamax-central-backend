class Social::ClientsController < ApplicationController
  before_action :admin_authorize_request, except: %i[phone create change_address]
  before_action :set_social_client, only: %i[ show update destroy ]

  # GET /social/clients
  def index
    @social_clients = Social::Client.all
    render json: @social_clients, status: :ok
  end

  # GET /social/clients/1
  def show
    render json: @social_client
  end

  # GET /social/clients/phone?phone={params}
  def phone
    @social_client = Social::Client.find_by(phone: params[:phone])
    if @social_client
      render json: @social_client, status: :ok
    else
      render json: { error: 'Client not found' }, status: :not_found
    end
  end

  # POST /social/clients
  def create
    @social_client = Social::Client.new(social_client_params)
    if @social_client.save
      render json: @social_client, status: :created
    else
      render json: @social_client.errors, status: :unprocessable_entity
    end
  end

  # PUT /social/clients/change_address
  def change_address
    @social_client = Social::Client.find(change_direction_params[:id])
    if @social_client.update(change_direction_params)
      render json: @social_client, status: :ok
    else
      render json: @social_client.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /social/clients/1
  def update
    if @social_client.update(social_client_params)
      render json: @social_client, status: :ok
    else
      render json: @social_client.errors, status: :unprocessable_entity
    end
  end

  # DELETE /social/clients/1
  def destroy
    @social_client.destroy

    render json: { message: 'Client deleted', client: @social_client }, status: :ok
  end

  private

  def set_social_client
    @social_client = Social::Client.find(params[:id])
  end

  def social_client_params
    params.require(:social_client).permit(:name, :email, :phone, :address, :country, :province, :zip_code)
  end

  def change_direction_params
    params.require(:social_client).permit(:id, :address, :country, :province, :zip_code)
  end
end
