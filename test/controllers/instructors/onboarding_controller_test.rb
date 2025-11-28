require "test_helper"

class Instructors::OnboardingControllerTest < ActionDispatch::IntegrationTest
  test "should get refresh" do
    get instructors_onboarding_refresh_url
    assert_response :success
  end

  test "should get return" do
    get instructors_onboarding_return_url
    assert_response :success
  end
end
