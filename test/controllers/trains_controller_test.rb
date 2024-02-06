require "test_helper"

class TrainsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @train = trains(:one)
  end

  test "should get index" do
    get trains_url, as: :json
    assert_response :success
  end

  test "should create train" do
    assert_difference("Train.count") do
      post trains_url, params: { train: { beginning_station: @train.beginning_station, destination_station: @train.destination_station, end_time: @train.end_time, no_of_seats: @train.no_of_seats, price_for_stop: @train.price_for_stop, start_time: @train.start_time, stops: @train.stops, train_name: @train.train_name, train_number: @train.train_number } }, as: :json
    end

    assert_response :created
  end

  test "should show train" do
    get train_url(@train), as: :json
    assert_response :success
  end

  test "should update train" do
    patch train_url(@train), params: { train: { beginning_station: @train.beginning_station, destination_station: @train.destination_station, end_time: @train.end_time, no_of_seats: @train.no_of_seats, price_for_stop: @train.price_for_stop, start_time: @train.start_time, stops: @train.stops, train_name: @train.train_name, train_number: @train.train_number } }, as: :json
    assert_response :success
  end

  test "should destroy train" do
    assert_difference("Train.count", -1) do
      delete train_url(@train), as: :json
    end

    assert_response :no_content
  end
end
