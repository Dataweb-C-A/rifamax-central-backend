class X100::InvoicesController < ApplicationController
  before_action :authorize_request
  before_action :validates_admin

  def index
    render json: { message: "Ok" }, status: :ok
  end

  private

  def invoice_params
    params.require(:invoice).permit(:date_init, :date_end, :client, :taquilla)
  end

  def validates_admin
    render json: { message: 'You are not authorized to perform this action' }, status: :unauthorized unless @current_user.Admin?
  end
end
