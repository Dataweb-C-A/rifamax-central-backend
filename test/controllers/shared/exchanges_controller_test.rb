require "test_helper"

class Shared::ExchangesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @shared_exchange = shared_exchanges(:one)
  end

  test "should get index" do
    get shared_exchanges_url, as: :json
    assert_response :success
  end

  test "should create shared_exchange" do
    assert_difference("Shared::Exchange.count") do
      post shared_exchanges_url, params: { shared_exchange: {  } }, as: :json
    end

    assert_response :created
  end

  test "should show shared_exchange" do
    get shared_exchange_url(@shared_exchange), as: :json
    assert_response :success
  end

  test "should update shared_exchange" do
    patch shared_exchange_url(@shared_exchange), params: { shared_exchange: {  } }, as: :json
    assert_response :success
  end

  test "should destroy shared_exchange" do
    assert_difference("Shared::Exchange.count", -1) do
      delete shared_exchange_url(@shared_exchange), as: :json
    end

    assert_response :no_content
  end
end
