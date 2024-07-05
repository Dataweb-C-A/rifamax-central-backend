require "test_helper"

class Social::PaymentMethodsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get social_payment_methods_index_url
    assert_response :success
  end
end
