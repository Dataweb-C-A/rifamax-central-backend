module X100
  class DrawsController < ApplicationController
    before_action :authorize_request

    def raffle_stats
      @raffles = X100::Raffle.active_raffles_for_user(@current_user)
      render json: @raffles, status: :ok
    end
  end
end