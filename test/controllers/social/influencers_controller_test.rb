require "test_helper"

class Social::InfluencersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get social_influencers_index_url
    assert_response :success
  end
end
