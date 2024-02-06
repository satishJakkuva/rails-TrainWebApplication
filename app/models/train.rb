class Train
  include Mongoid::Document
  include Mongoid::Timestamps
  field :train_name, type: String
  field :train_number, type: String
  field :no_of_seats, type: Integer
  field :beginning_station, type: String
  field :destination_station, type: String
  field :stops, type: Array
  field :price_for_stop, type: Hash
  field :start_time, type: DateTime
  field :end_time, type: DateTime
  field :bookings_id ,type: BSON::ObjectId

  def bookings
    Booking.where(bookings_id: bookings_id)
  end
end
