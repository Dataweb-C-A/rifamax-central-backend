require "test_helper"

class X100::ClientsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @x100_client = x100_clients(:one)
  end

  test "should get index" do
    get x100_clients_url, as: :json
    assert_response :success
  end

  test "should create x100_client" do
    assert_difference("X100::Client.count") do
      post x100_clients_url, params: { x100_client: { dni: @x100_client.dni, email: @x100_client.email, name: @x100_client.name, phone: @x100_client.phone } }, as: :json
    end

    assert_response :created
  end

  test "should show x100_client" do
    get x100_client_url(@x100_client), as: :json
    assert_response :success
  end

  test "should update x100_client" do
    patch x100_client_url(@x100_client), params: { x100_client: { dni: @x100_client.dni, email: @x100_client.email, name: @x100_client.name, phone: @x100_client.phone } }, as: :json
    assert_response :success
  end

  test "should destroy x100_client" do
    assert_difference("X100::Client.count", -1) do
      delete x100_client_url(@x100_client), as: :json
    end

    assert_response :no_content
  end
end
