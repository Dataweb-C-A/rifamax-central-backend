class Social::DetailsController < ApplicationController
  before_action :authorize_request
  before_action :validates_admin, only: %i[admin]

  def index
    details = @current_user.influencer_details

    render json: details, status: :ok
  end

  def admin
    details = Social::Influencer.find_by(content_code: admin_details_params[:content_code]).shared_user.influencer_details

    render json: details, status: :ok

    rescue NoMethodError
      render json: { error: 'Influencer not found' }, status: :not_found
  end

  private

  def admin_details_params
    params.permit(:content_code)
  end

  def validates_admin
    return unless @current_user.role != 'Admin'

    render json: { error: 'Unauthorized' }, status: :unauthorized
  end
end
