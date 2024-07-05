require "test_helper"

class Social::NetworksControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get social_networks_create_url
    assert_response :success
  end
end
