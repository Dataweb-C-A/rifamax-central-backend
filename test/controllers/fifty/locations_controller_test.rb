require "test_helper"

class Fifty::LocationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @fifty_location = fifty_locations(:one)
  end

  test "should get index" do
    get fifty_locations_url, as: :json
    assert_response :success
  end

  test "should create fifty_location" do
    assert_difference("Fifty::Location.count") do
      post fifty_locations_url, params: { fifty_location: { country: @fifty_location.country, state: @fifty_location.state } }, as: :json
    end

    assert_response :created
  end

  test "should show fifty_location" do
    get fifty_location_url(@fifty_location), as: :json
    assert_response :success
  end

  test "should update fifty_location" do
    patch fifty_location_url(@fifty_location), params: { fifty_location: { country: @fifty_location.country, state: @fifty_location.state } }, as: :json
    assert_response :success
  end

  test "should destroy fifty_location" do
    assert_difference("Fifty::Location.count", -1) do
      delete fifty_location_url(@fifty_location), as: :json
    end

    assert_response :no_content
  end
end
