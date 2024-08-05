class Dev::FeatureFlagsController < ApplicationController
  before_action :admin_authorize_request

  # GET /dev/feature_flags
  def index
    @feature_flags = Dev::FeatureFlag.all
    render json: @feature_flags, status: :ok
  end

  # GET /dev/feature_flags/search?name={name}
  def search
    @feature_flag = Dev::FeatureFlag.find_by(name: params[:name])
    if @feature_flag
      render json: @feature_flag, status: :ok
    else
      render json: { error: 'Feature flag not found' }, status: :not_found
    end
  end
end
