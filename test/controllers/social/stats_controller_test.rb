require "test_helper"

class Social::StatsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get social_stats_index_url
    assert_response :success
  end
end
