require "test_helper"

class Students::CheckoutsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get students_checkouts_create_url
    assert_response :success
  end

  test "should get success" do
    get students_checkouts_success_url
    assert_response :success
  end
end
