require "test_helper"

class Dev::ToolsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get dev_tools_index_url
    assert_response :success
  end

  test "should get restart" do
    get dev_tools_restart_url
    assert_response :success
  end
end
