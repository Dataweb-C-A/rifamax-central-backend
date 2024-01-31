module X100
  class DrawsController < ApplicationController
    before_action :authorize_request

    def raffle_stats
      @raffles = X100::Raffle.raffles_by_user(@current_user)
      render json: @raffles, each_serializer: X100::DrawSerializer, status: :ok
    end
  end
end