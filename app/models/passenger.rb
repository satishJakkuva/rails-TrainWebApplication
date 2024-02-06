class Passenger
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  field :age, type: Integer
  field :gender, type: String
  field :email, type: String
  field :phone, type: String
  field :bookings_id, type: BSON::ObjectId
  def bookings
    Booking.where(bookings_id: bookings_id)
  end
end
