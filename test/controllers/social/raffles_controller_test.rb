require "test_helper"

class Social::RafflesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @social_raffle = social_raffles(:one)
  end

  test "should get index" do
    get social_raffles_url, as: :json
    assert_response :success
  end

  test "should create social_raffle" do
    assert_difference("Social::Raffle.count") do
      post social_raffles_url, params: { social_raffle: {  } }, as: :json
    end

    assert_response :created
  end

  test "should show social_raffle" do
    get social_raffle_url(@social_raffle), as: :json
    assert_response :success
  end

  test "should update social_raffle" do
    patch social_raffle_url(@social_raffle), params: { social_raffle: {  } }, as: :json
    assert_response :success
  end

  test "should destroy social_raffle" do
    assert_difference("Social::Raffle.count", -1) do
      delete social_raffle_url(@social_raffle), as: :json
    end

    assert_response :no_content
  end
end
