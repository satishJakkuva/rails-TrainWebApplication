class BookingsController < ApplicationController
  include BookingValidation
  before_action :set_booking, only: %i[ show cancel_booking]

  # GET /bookings
  def index
    @bookings = Booking.all

    render json: @bookings
  end

  # GET /bookings/1
  def show
    render json: @booking
  end
  def combination_search
    search_params = params.permit(:pnr_number, :train_name, :train_number, :date_of_booking, :email, :phone)
    conditions = {}
  
    search_params.each do |key, value|
      case key
      when 'date_of_booking'
        parse_date = DateTime.parse(value) rescue nil
        conditions[:date_of_booking] = parse_date if parse_date.present?
      when 'train_name', 'train_number'
        train_conditions = { key.to_sym => /#{value}/i } if value.present?
        conditions[:train_id.in] = Train.where(train_conditions).pluck(:_id) if train_conditions.present?
      else
        conditions[key.to_sym] = /#{value}/i if value.present?
      end
    end
  
    bookings = Booking.where(conditions)
    
  
    result = bookings.map do |booking|
      passengers_data = booking.passengers.map do |passenger|
        {
          email: passenger.email,
          phone: passenger.phone
        }
      end
      {
        pnr_number: booking.pnr_number,
        train_name: booking.train.train_name,
        train_number: booking.train.train_number,
        passengers: passengers_data,
        date_of_booking: booking.date_of_booking,
        seats: booking.seats,
        status: booking.status,
        travel_date: booking.travel_date
      }
    end
    render json: result
  end
  
  def create
    errors=[]
    @booking = Booking.new(booking_params)
    @booking.pnr_number=generate_pnr_number

    errors << SEATS_REQUIRED unless @booking.seats.present?
  
    if errors.present?
      render json:{errors: errors}
      return
    end
    booking_validation_errors = validate_booking(@booking)
    if booking_validation_errors.empty?
      @booking.save
      render json: {message: "booking created successfully"}
    else
      render json: {errors: booking_validation_errors} 
    end
  end

  # api to cancel the booking
  def cancel_booking 
    if @booking.present?
      @booking.status = 'cancelled'
      if @booking.save
        render json: { message: 'booking canceled succesfully' }, status: :ok
      else
        render json: { message: 'failed to cancel booking' }, status: :unprocessable_entity
      end
    else
      render json: { message: 'booking id not found' }, status: :unprocessable_entity
    end
  end

  def change_schedule 
    begin
    booking = Booking.find(params[:id])
    if booking.present?
      if booking.status&.casecmp('cancelled') != 0
        travel_date_param = params[:travel_date]
        if travel_date_param > booking.travel_date
          booking.travel_date = travel_date_param
          if booking.save 
            render json: { message: 'schedule changed successfully' }, status: :ok
          else
            render json: { message: 'failed to change schedule' }, status: :unprocessable_entity
          end
        else
          render json: { message: 'schedule must be in future' }, status: :unprocessable_entity
        end
      else
        render json: {message: "booking status should be confirmed to change the schedule"}
      end
    else
      render json: { messsage: 'no booking found' }, status: :not_found
    end
  rescue Mongoid::Errors::DocumentNotFound
    render json:{message: "booking id not found"}
  end
  end

  private
    def set_booking
      begin
      @booking = Booking.find(params[:id])
      rescue Mongoid::Errors::DocumentNotFound
        render json: {message: "booking id not found"}
      end
    end

    def booking_params
      params.require(:booking).permit(:seats,:from_station,:destination_station,:date_of_booking,:travel_date,:status,:passengers_id,:train_id)
    end
   
    def generate_pnr_number
      unique_pnr = loop do
        random_digits = SecureRandom.random_number(10**10)
        pnr_number = "PNR#{random_digits}"
        break pnr_number unless Booking.exists?(pnr_number: pnr_number)
      end
      unique_pnr
    end
       
end
