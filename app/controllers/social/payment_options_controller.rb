class Social::PaymentOptionsController < ApplicationController
  before_action :admin_authorize_request, only: %i[ create ]
 
  def create
    @social_payment_option = Social::PaymentOption.new(social_payment_option_params)
    if @social_payment_option.save
      render json: @social_payment_option, status: :created
    else
      render json: @social_payment_option.errors, status: :unprocessable_entity
    end
  end

  private

  def social_payment_option_params
    params.require(:social_payment_option).permit(
      :name,
      :country,
      :social_influencer_id,
      details: [:bank, :name, :dni, :phone, :email]
    )
  end
end
