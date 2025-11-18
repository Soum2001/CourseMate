require "test_helper"

class Students::CartItemsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get students_cart_items_create_url
    assert_response :success
  end

  test "should get destroy" do
    get students_cart_items_destroy_url
    assert_response :success
  end
end
