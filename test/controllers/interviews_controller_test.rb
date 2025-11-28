require "test_helper"

class InterviewsControllerTest < ActionDispatch::IntegrationTest
  test "should get language" do
    get interviews_language_url
    assert_response :success
  end

  test "should get questions" do
    get interviews_questions_url
    assert_response :success
  end

  test "should get result" do
    get interviews_result_url
    assert_response :success
  end
end
