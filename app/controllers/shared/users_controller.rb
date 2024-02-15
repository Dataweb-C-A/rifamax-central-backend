# frozen_string_literal: true

module Shared
  class UsersController < ApplicationController
    before_action :set_shared_user, only: %i[show update destroy]
    before_action :authorize_request
    before_action :allow_if_user_is_admin, except: %i[profile]

    # GET /shared/users
    def index
      @shared_users = Shared::User.all

      render json: @shared_users
    end

    def profile
      render json: @current_user
    end

    # GET /shared/users/1
    def show
      render json: @shared_user
    end

    # POST /shared/users
    def create
      @shared_user = Shared::User.new(shared_user_params)

      if @shared_user.save
        render json: @shared_user, status: :created, location: @shared_user
      else
        render json: @shared_user.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /shared/users/1
    def update
      if @shared_user.update(shared_user_params)
        render json: @shared_user
      else
        render json: @shared_user.errors, status: :unprocessable_entity
      end
    end

    # DELETE /shared/users/1
    def destroy
      if @shared_user.destroy
        render json: { message: 'User deleted', user: @shared_user }, status: :ok, location: @shared_user
      else
        render json: @shared_user.errors, status: :unprocessable_entity
      end
    end

    private

    def allow_if_user_is_admin
      render json: { error: 'Not Authorized' }, status: 401 unless @current_user.role == 'Admin'
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_shared_user
      @shared_user = Shared::User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def shared_user_params
      params.require(:shared_user).permit(:avatar, :name, :role, :dni, :email, :phone, :password_digest, :slug,
                                          :is_active, :module_assigned)
    end
  end
end
