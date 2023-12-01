require "test_helper"

class X100::RafflesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @x100_raffle = x100_raffles(:one)
  end

  test "should get index" do
    get x100_raffles_url, as: :json
    assert_response :success
  end

  test "should create x100_raffle" do
    assert_difference("X100::Raffle.count") do
      post x100_raffles_url, params: { x100_raffle: {  } }, as: :json
    end

    assert_response :created
  end

  test "should show x100_raffle" do
    get x100_raffle_url(@x100_raffle), as: :json
    assert_response :success
  end

  test "should update x100_raffle" do
    patch x100_raffle_url(@x100_raffle), params: { x100_raffle: {  } }, as: :json
    assert_response :success
  end

  test "should destroy x100_raffle" do
    assert_difference("X100::Raffle.count", -1) do
      delete x100_raffle_url(@x100_raffle), as: :json
    end

    assert_response :no_content
  end
end
