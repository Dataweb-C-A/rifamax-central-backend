require 'pagy/extras/array'

module X100
  class DrawsController < ApplicationController
    include Pagy::Backend

    before_action :authorize_request

    def raffle_stats
      items_per_page = params[:items_per_page].to_i.positive? ? params[:items_per_page].to_i : 10
      current_page = params[:current_page].to_i.positive? ? params[:current_page].to_i : 1

      @raffles = X100::Raffle.raffles_by_user(@current_user)
      @pagy, @paginated_raffles = pagy_array(@raffles, items: items_per_page, page: current_page)
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