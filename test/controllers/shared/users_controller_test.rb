# frozen_string_literal: true

require 'test_helper'

module Shared
  class UsersControllerTest < ActionDispatch::IntegrationTest
    setup do
      @shared_user = shared_users(:one)
    end

    test 'should get index' do
      get shared_users_url, as: :json
      assert_response :success
    end

    test 'should create shared_user' do
      assert_difference('Shared::User.count') do
        post shared_users_url,
             params: { shared_user: { avatar: @shared_user.avatar, dni: @shared_user.dni, email: @shared_user.email, is_active: @shared_user.is_active, module_assigned: @shared_user.module_assigned, name: @shared_user.name, password_digest: @shared_user.password_digest, phone: @shared_user.phone, role: @shared_user.role, slug: @shared_user.slug } }, as: :json
      end

      assert_response :created
    end

    test 'should show shared_user' do
      get shared_user_url(@shared_user), as: :json
      assert_response :success
    end

    test 'should update shared_user' do
      patch shared_user_url(@shared_user),
            params: { shared_user: { avatar: @shared_user.avatar, dni: @shared_user.dni, email: @shared_user.email, is_active: @shared_user.is_active, module_assigned: @shared_user.module_assigned, name: @shared_user.name, password_digest: @shared_user.password_digest, phone: @shared_user.phone, role: @shared_user.role, slug: @shared_user.slug } }, as: :json
      assert_response :success
    end

    test 'should destroy shared_user' do
      assert_difference('Shared::User.count', -1) do
        delete shared_user_url(@shared_user), as: :json
      end

      assert_response :no_content
    end
  end
end
