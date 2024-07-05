require "test_helper"

class Social::DetailsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get social_details_index_url
    assert_response :success
  end
end
