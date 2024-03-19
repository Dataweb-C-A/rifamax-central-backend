require "test_helper"

class X100::InvoicesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get x100_invoices_index_url
    assert_response :success
  end

  test "should get filter" do
    get x100_invoices_filter_url
    assert_response :success
  end
end
