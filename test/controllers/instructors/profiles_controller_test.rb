require "test_helper"

class Instructors::ProfilesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get instructors_profiles_show_url
    assert_response :success
  end

  test "should get edit" do
    get instructors_profiles_edit_url
    assert_response :success
  end

  test "should get update" do
    get instructors_profiles_update_url
    assert_response :success
  end
end
