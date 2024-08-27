require "test_helper"

class Rifamax::AgenciesControllerTest < ActionDispatch::IntegrationTest
  test "should get my_agencies" do
    get rifamax_agencies_my_agencies_url
    assert_response :success
  end
end
