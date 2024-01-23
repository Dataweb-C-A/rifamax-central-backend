# frozen_string_literal: true

class ApplicationController < ActionController::API
  def not_found
    render json: { error: 'Not found' }
  end

  def unauthorized_message
    render json: { message: 'You are not authorized to perform this action' }, status: :unauthorized
  end

  def authorize_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      @decoded = JsonWebToken.decode(header)
      @current_user = Shared::User.find(@decoded[:user_id])

      def verify_role(role)
        return true if @current_user.role == role

        unauthorized_message
      end

      def verify_roles(roles)
        return true if roles.include?(@current_user.role)

        unauthorized_message
      end
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end
end
