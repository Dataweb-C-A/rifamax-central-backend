require "test_helper"

class X100::DrawsControllerTest < ActionDispatch::IntegrationTest
  test "should get raffle_stats" do
    get x100_draws_raffle_stats_url
    assert_response :success
  end
end
