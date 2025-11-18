require "test_helper"

class Student::CartsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get student_carts_index_url
    assert_response :success
  end

  test "should get create" do
    get student_carts_create_url
    assert_response :success
  end

  test "should get destroy" do
    get student_carts_destroy_url
    assert_response :success
  end
end
