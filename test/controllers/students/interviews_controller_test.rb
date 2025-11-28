require "test_helper"

class Students::InterviewsControllerTest < ActionDispatch::IntegrationTest
  test "should get language" do
    get students_interviews_language_url
    assert_response :success
  end

  test "should get questions" do
    get students_interviews_questions_url
    assert_response :success
  end

  test "should get result" do
    get students_interviews_result_url
    assert_response :success
  end
end
