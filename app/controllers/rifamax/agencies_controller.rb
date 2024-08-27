class Rifamax::AgenciesController < ApplicationController
  before_action :authorize_request

  def index
    if @current_user.role === 'Taquilla'
      render json: [@current_user], status: :ok
    else
      agencies = Shared::User.select{ |user| user.rifero_ids.include?(@current_user.id) }
      render json: agencies, status: :ok
    end
  end
end
