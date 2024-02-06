class TrainsController < ApplicationController
  include TrainValidation
  before_action :set_train, only: %i[ show update destroy ]

  def index
    @trains = Train.all

    render json: @trains
  end

  def show
    render json: @train
  end
  def create
    errors=[]
    @train = Train.new(train_params)

    errors << TRAIN_NUMBER_REQUIRED unless @train.train_number.present?
    errors << BEGINNING_STATION_REQUIRED unless @train.beginning_station.present?
    errors << DESTINATION_STATION_REQUIRED unless @train.destination_station.present?
    errors << TRAIN_NAME_REQUIRED unless @train.train_name.present?
    errors << START_TIME_REQUIRED unless @train.start_time.present?
    errors << END_TIME_REQUIRED unless @train.end_time.present?
    errors << STOPS_REQUIRED unless @train.stops.present?

    if errors.present?
      render json:{errors: errors}
      return
    end
    train_validation_errors = validate_train(@train)
    if train_validation_errors.empty?
      @train.save
      render json: {message: "train details created successfully"}
    else
      render json:{errors:train_validation_errors}
    end
  end

  def combination_search
    search_params = params.permit(:train_name, :train_number, :seats,
                                  :beginning_station, :destination_station,
                                  :start_time, :end_time)
    conditions = {}
    search_params.each do |key, value|
      case key
      when 'start_time'
        parse_time = DateTime.parse(value) rescue nil
        conditions[:start_time] = parse_time if parse_time.present?
      when 'end_time'
        parse_time = DateTime.parse(value) rescue nil
        conditions[:end_time] = parse_time if parse_time.present?
      else
        conditions[key.to_sym] = /#{value}/i if value.present?
      end
  end
    @train_details = Train.where(conditions)
    render json: (@train_details.present? ? @train_details : { message: 'no records found' }),
           status: :not_found
  end
  
  def update
    if @train.update(train_params)
      render json: { message: "train details updated successfully"}
    else
      render json: {message: "failed to update train details "}
    end
  end

  def destroy
    @train.destroy!
    render json: {message: "train details deleted successfully"}
  end

  private
    def set_train
      begin 
      @train = Train.find(params[:id])
      rescue Mongoid::Errors::DocumentNotFound
        render json: {message: "train id not found"}
      end
    end

    def train_params
      params.require(:train).permit(:train_name, :train_number, :no_of_seats, :beginning_station, :destination_station,:start_time, :end_time,:bookings_id,stops: [],price_for_stop: {})
    end

end
