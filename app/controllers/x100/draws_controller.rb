module X100
  class DrawsController < ApplicationController
    include Pagy::Backend
    
    before_action :authorize_request

    def raffle_stats
      @raffles = X100::Raffle.raffles_by_user(@current_user)
      pagy, @paginated_raffles = pagy(@raffles)
      render json: {
        raffles: @paginated_raffles,
        pagination: pagy_metadata(pagy)
      }, each_serializer: X100::DrawSerializer, status: :ok
    end
  end
end