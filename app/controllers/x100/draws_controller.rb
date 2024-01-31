require 'pagy/extras/array'

module X100
  class DrawsController < ApplicationController
    include Pagy::Backend

    before_action :authorize_request

    def raffle_stats
      @raffles = X100::Raffle.raffles_by_user(@current_user)
      @pagy, @paginated_raffles = pagy_array(@raffles, items: params[:items_per_page].to_i || 10, page: params[:current_page].to_i || 1)
      render json: {
        raffles: @paginated_raffles,
        metadata: {
          page: @pagy.page,
          count: @pagy.count,
          items: @pagy.items,
          pages: @pagy.pages
        }
      }, each_serializer: X100::DrawSerializer, status: :ok
    end
  end
end