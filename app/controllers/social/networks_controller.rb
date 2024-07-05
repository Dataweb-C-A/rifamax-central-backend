class Social::NetworksController < ApplicationController
  before_action :authorize_request, only: %i[create]
  before_action :allow_if_user_is_admin, only: %i[create]

  # POST /social/networks
  def create
    @network = Social::Network.new(network_params)

    if @network.save
      render json: @network, status: :created
    else
      render json: @network.errors, status: :unprocessable_entity
    end
  end

  private

  def network_params
    params.require(:social_network).permit(:name, :username, :url, :social_influencer_id)
  end

  def allow_if_user_is_admin
    render json: { error: 'Not Authorized' }, status: 401 unless @current_user.role == 'Admin'
  end
end
