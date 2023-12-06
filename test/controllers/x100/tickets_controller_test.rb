# frozen_string_literal: true

require 'test_helper'

module X100
  class TicketsControllerTest < ActionDispatch::IntegrationTest
    test 'should get index' do
      get x100_tickets_index_url
      assert_response :success
    end

    test 'should get sold' do
      get x100_tickets_sold_url
      assert_response :success
    end
  end
end
