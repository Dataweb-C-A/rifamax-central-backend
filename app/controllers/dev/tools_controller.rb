class Dev::ToolsController < ApplicationController
  require 'httparty'
  # before_action :authorize_request, only: [:server, :restart]

  def server
    server = JSON.parse($do_client.droplets.all.to_json)[0]

    render json: { server: server }, status: :ok
  end

  def restart_server
    server_id = JSON.parse($do_client.droplets.all.to_json)[0]["id"]
  end

  private

  def authorize_admin
    return if current_user.admin?
    render json: { error: 'Not Authorized' }, status: :unauthorized
  end
end
