require "test_helper"

class InstitutionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get institutions_new_url
    assert_response :success
  end

  test "should get create" do
    get institutions_create_url
    assert_response :success
  end
end
