class Social::PaymentMethodsController < ApplicationController
  include Pagy::Backend

  before_action :set_social_payment_method, only: %i[ accept reject show update destroy ]
  before_action :authorize_request, except: %i[ create ]
  before_action :authorize_role, only: %i[ accept reject ]

  # GET /social/payment_methods
  def index
    @social_payment_methods = Social::PaymentMethod.authorize(@current_user.id).active.order(created_at: :desc)
    count = params[:count] || 6
    page = params[:page] || 1
    @pagy, @records = pagy(@social_payment_methods, items: count, page: page)
    render json: { 
      social_payment_methods: ActiveModel::Serializer::CollectionSerializer.new(@records, each_serializer: Social::PaymentMethodSerializer), 
      metadata: {
        page: @pagy.page,
        count: @pagy.count,
        items: @pagy.items,
        pages: @pagy.pages
      }
    }, status: :ok
    rescue
      render json: { message: 'You dont have permission to perform this action' }, status: :forbidden
  end

  # GET /social/payment_methods/:id
  def show
    render json: @social_payment_method, status: :ok
  end

  # POST /social/payment_methods/:id/accept
  def accept
    unless @current_user.role.in?(@roles_authorized)
      render json: { message: 'You dont have permission to perform this action' }, status: :forbidden
    else
      if @social_payment_method.accept!
        @social_payment_method.status = 'accepted'
        render json: @social_payment_method, status: :ok
      else
        render json: @social_payment_method.errors, status: :unprocessable_entity
      end
    end
  end

  # POST /social/payment_methods/:id/reject
  def reject
    unless @current_user.role.in?(@roles_authorized)
      render json: { message: 'You dont have permission to perform this action' }, status: :forbidden
    else
      @social_payment_method.reject!
      @social_payment_method.status = 'rejected'
      render json: @social_payment_method, status: :ok
    end
  end

  def history
    @social_payment_methods = Social::PaymentMethod.authorize_with_payment(@current_user.id, params[:payment]).order(created_at: :desc)
    count = params[:count] || 8
    page = params[:page] || 1
    @pagy, @records = pagy(@social_payment_methods, items: count, page: page)
    render json: {
      social_payment_methods: ActiveModel::Serializer::CollectionSerializer.new(@records, each_serializer: Social::PaymentMethodSerializer),
      metadata: {
        page: @pagy.page,
        count: @pagy.count,
        items: @pagy.items,
        pages: @pagy.pages
      }
    }, status: :ok
    rescue
      render json: { message: 'You dont have permission to perform this action' }, status: :forbidden
  end

  # POST /social/payment_methods
  def create
    influencer = Social::Influencer.find_by(content_code: social_payment_method_params[:content_code])

    return render json: { message: 'Influencer must exists' }, status: :not_found unless influencer

    @social_payment_method = Social::PaymentMethod.new(social_payment_method_params.except(:content_code))
    @social_payment_method.social_influencer_id = influencer.id
    if @social_payment_method.save
      render json: @social_payment_method, status: :created
    else
      render json: @social_payment_method.errors, status: :unprocessable_entity
    end
  end

  # PUT /social/payment_methods/:id
  def update
    if @social_payment_method.update(social_payment_method_params)
      render json: @social_payment_method, status: :ok
    else
      render json: @social_payment_method.errors, status: :unprocessable_entity
    end
  end

  # DELETE /social/payment_methods/:id
  def destroy
    @social_payment_method.destroy
    render json: { message: 'Payment method deleted', payment_method: @social_payment_method }, status: :ok
  end

  private

  def set_social_payment_method
    @social_payment_method = Social::PaymentMethod.find(params[:id])
  end 

  def authorize_role
    @roles_authorized = ['Admin', 'Influencer']
  end

  def social_payment_method_params
    params.require(:social_payment_method).permit(
      :payment, 
      :amount, 
      :currency, 
      :status, 
      :content_code,
      :social_client_id,
      details: [:bank, :name, :last_digits, :dni, :phone, :email, :reference]
    )
  end
end
