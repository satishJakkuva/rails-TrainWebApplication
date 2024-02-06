class Booking
  include Mongoid::Document
  include Mongoid::Timestamps
  field :pnr_number, type: String
  field :seats, type: Integer
  field :from_station, type: String
  field :destination_station, type: String
  field :date_of_booking, type: DateTime
  field :travel_date, type: DateTime
  field :status, type: String
                             
  field :passenger_ids, type: BSON::ObjectId
  field :train_id, type: BSON::ObjectId

  def train
    Train.find(train_id)
  end

  def passengers
    Passenger.where(passengers_id: id)
  end
  # def passengers
  #   Passenger.find(passenger_ids)
  # end
end
