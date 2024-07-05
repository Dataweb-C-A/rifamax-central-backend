# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Pagy::Backend
  
  def not_found
    render json: { error: 'Not found' }
  end

  def unauthorized_message
    render json: { message: 'You are not authorized to perform this action' }, status: :unauthorized
  end

  def render_to_channel
    @tickets = X100::Ticket.all_sold_tickets
    ActionCable.server.broadcast("x100_tickets", @tickets)
  end

  def authorize_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      structure = Shared::Structure.find_by(token: header.to_s)

      if structure
        @current_user = structure.shared_user
      else
        @decoded = JsonWebToken.decode(header)
        @current_user = Shared::User.find(@decoded[:user_id])
      end
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end

  def admin_authorize_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      structure = Shared::Structure.find_by(token: header.to_s)

      if structure
        @current_user = structure.shared_user
      else
        @decoded = JsonWebToken.decode(header)
        @current_user = Shared::User.find(@decoded[:user_id])
      end
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    rescue @current_user.role != 'admin'
      render json: { errors: 'You are not authorized to perform this action' }, status: :unauthorized
    end
  end

  def soft_authorize_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      structure = Shared::Structure.find_by(token: header.to_s)

      if structure
        @soft_user = structure.shared_user
      else
        @decoded = JsonWebToken.decode(header)
        @token = header
        @soft_user = Shared::User.find(@decoded[:user_id])
      end
    rescue JWT::ExpiredSignature
      render json: { error: 'Token expired' }, status: :unauthorized
    rescue JWT::VerificationError
      render json: { error: 'Invalid Token' }, status: :forbidden
    rescue JWT::DecodeError
      render json: { error: 'Invalid Token' }, status: :forbidden
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :forbidden
    end
  end
end
