class Social::StatsController < ApplicationController
  before_action :authorize_request, only: %i[specific]

  def specific
    allowed_roles = %w[Admin Influencer]
    @stats = Social::Raffle.find(params[:id]).stats

    if allowed_roles.include?(@current_user.role)
      render json: @stats, status: :ok
    else
      render json: { error: "You can't handle this action" }, status: :forbidden
    end

    # rescue
    #   render json: { error: "You can't handle this action" }, status: :not_found
  end
end
