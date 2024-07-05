class Social::InfluencersController < ApplicationController
  include Pagy::Backend

  before_action :authorize_request, only: %i[all]
  before_action :validates_admin, only: %i[all]

  def index
    @influencer = Social::Influencer.find_by(content_code: params[:content_code])
    if @influencer
      render json: @influencer.shared_user, status: :ok, status: :ok
    else
      render json: { message: 'Influencer not found' }, status: :not_found
    end
  end

  def all
    @influencers = Social::Influencer.all
    count = params[:count] || 6
    page = params[:page] || 1

    @pagy, @records = pagy(@influencers, items: count, page: page)
    render json: { 
      influencers: ActiveModel::Serializer::CollectionSerializer.new(@records, each_serializer: Social::InfluencerSerializer), 
      metadata: {
        page: @pagy.page,
        count: @pagy.count,
        items: @pagy.items,
        pages: @pagy.pages
      }
    }, status: :ok

    rescue Pagy::OverflowError
      render json: { error: 'Pagy Out of range' }, status: 400
  end

  private

  def validates_admin
    return unless @current_user.role != 'Admin'

    render json: { error: 'Unauthorized' }, status: :unauthorized
  end
end
