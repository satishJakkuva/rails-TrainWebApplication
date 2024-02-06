require "test_helper"

class PassengersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @passenger = passengers(:one)
  end

  test "should get index" do
    get passengers_url, as: :json
    assert_response :success
  end

  test "should create passenger" do
    assert_difference("Passenger.count") do
      post passengers_url, params: { passenger: { age: @passenger.age, email: @passenger.email, gender: @passenger.gender, name: @passenger.name, phone: @passenger.phone } }, as: :json
    end

    assert_response :created
  end

  test "should show passenger" do
    get passenger_url(@passenger), as: :json
    assert_response :success
  end

  test "should update passenger" do
    patch passenger_url(@passenger), params: { passenger: { age: @passenger.age, email: @passenger.email, gender: @passenger.gender, name: @passenger.name, phone: @passenger.phone } }, as: :json
    assert_response :success
  end

  test "should destroy passenger" do
    assert_difference("Passenger.count", -1) do
      delete passenger_url(@passenger), as: :json
    end

    assert_response :no_content
  end
end
