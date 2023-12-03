# frozen_string_literal: true

require 'test_helper'

module Fifty
  class StadiaControllerTest < ActionDispatch::IntegrationTest
    setup do
      @fifty_stadium = fifty_stadia(:one)
    end

    test 'should get index' do
      get fifty_stadia_url, as: :json
      assert_response :success
    end

    test 'should create fifty_stadium' do
      assert_difference('Fifty::Stadium.count') do
        post fifty_stadia_url,
             params: { fifty_stadium: { location_id: @fifty_stadium.location_id, name: @fifty_stadium.name } }, as: :json
      end

      assert_response :created
    end

    test 'should show fifty_stadium' do
      get fifty_stadium_url(@fifty_stadium), as: :json
      assert_response :success
    end

    test 'should update fifty_stadium' do
      patch fifty_stadium_url(@fifty_stadium),
            params: { fifty_stadium: { location_id: @fifty_stadium.location_id, name: @fifty_stadium.name } }, as: :json
      assert_response :success
    end

    test 'should destroy fifty_stadium' do
      assert_difference('Fifty::Stadium.count', -1) do
        delete fifty_stadium_url(@fifty_stadium), as: :json
      end

      assert_response :no_content
    end
  end
end
