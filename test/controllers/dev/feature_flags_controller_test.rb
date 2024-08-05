require "test_helper"

class Dev::FeatureFlagsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get dev_feature_flags_index_url
    assert_response :success
  end
end
