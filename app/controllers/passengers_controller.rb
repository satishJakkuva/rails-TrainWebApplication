class PassengersController < ApplicationController
  include PassengerValidation
  before_action :set_passenger, only: %i[ show update destroy ]

  def index
    @passengers = Passenger.all
    render json: @passengers
  end

  def show
    render json: @passenger
  end

  def create
    errors=[]
    @passenger = Passenger.new(passenger_params)
    errors << GENDER_REQUIRED unless @passenger.gender.present?
    errors << PHONE_NUMBER_REQUIRED unless @passenger.phone.present?
    errors << AGE_REQUIRED unless @passenger.age.present?
    errors << EMAIL_REQUIIRED unless @passenger.email.present?
    errors << NAME_REQUIRED unless @passenger.name.present?

    if errors.present?
      render json:{errors: errors}
      return
    end
    passenger_validation_errors= validate_passenger(@passenger)
   if passenger_validation_errors.empty?
     @passenger.save
      render json: {message: "passenger created successfully"}
    else
      render json:{errors: passenger_validation_errors}
    end
  end

  def update
    if @passenger.update(passenger_params)
      render json: {message:"passenger updated successfully"}
    else
      render json: @passenger.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @passenger.destroy!
    render json: {message:"passenger deleted successfully"}
  end

  private
    def set_passenger
      begin
      @passenger = Passenger.find(params[:id])
      rescue Mongoid::Errors::DocumentNotFound
        render json: {message:"passenger id not found"}
      end
    end

    def passenger_params
      params.require(:passenger).permit(:name, :age, :gender, :email, :phone)
    end
end
