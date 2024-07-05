require "test_helper"

class Social::PaymentOptionsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get social_payment_options_index_url
    assert_response :success
  end
end
