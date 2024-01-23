# frozen_string_literal: true

require 'test_helper'

module X100
  class OrdersControllerTest < ActionDispatch::IntegrationTest
    setup do
      @x100_order = x100_orders(:one)
    end

    test 'should get index' do
      get x100_orders_url, as: :json
      assert_response :success
    end

    test 'should create x100_order' do
      assert_difference('X100::Order.count') do
        post x100_orders_url,
             params: { x100_order: { amount: @x100_order.amount, ordered_at: @x100_order.ordered_at, products: @x100_order.products, serial: @x100_order.serial, shared_user_id: @x100_order.shared_user_id, x100_client_id: @x100_order.x100_client_id } }, as: :json
      end

      assert_response :created
    end

    test 'should show x100_order' do
      get x100_order_url(@x100_order), as: :json
      assert_response :success
    end

    test 'should update x100_order' do
      patch x100_order_url(@x100_order),
            params: { x100_order: { amount: @x100_order.amount, ordered_at: @x100_order.ordered_at, products: @x100_order.products, serial: @x100_order.serial, shared_user_id: @x100_order.shared_user_id, x100_client_id: @x100_order.x100_client_id } }, as: :json
      assert_response :success
    end

    test 'should destroy x100_order' do
      assert_difference('X100::Order.count', -1) do
        delete x100_order_url(@x100_order), as: :json
      end

      assert_response :no_content
    end
  end
end
