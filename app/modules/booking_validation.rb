module BookingValidation
    include InvalidConstants
def validate_booking(booking)
    errors=[]
    errors << INVALID_SEATS unless validate_seats(booking.seats)
    errors << INVALID_FROM_STATION unless validate_from_station(booking.from_station,booking.train)
    errors << INVALID_BOOKING_DESTINATION_STATION unless validate_destination_station(booking.from_station,booking.destination_station,booking.train)

    errors
end
private
def validate_seats(seats)
    if !seats.blank? && seats >0
        return true
    else
        return false
    end
end

def validate_from_station(from_station, train)
    return true if from_station.blank? || train.blank?
    valid_stations = [train.beginning_station] + train.stops
    valid_stations.include?(from_station)
end
# def validate_destination_station(from_station,destination_station,train)
#     return if from_station.blank? || destination_station.blank?
#     return if train.blank?
#     stops = [train.beginning_station] + train.stops
#     unless stops.include?(from_station) && stops.include?(destination_station) &&
#            stops.index(from_station) < stops.index(destination_station)
#     end
# end
def validate_destination_station(from_station,destination_station,train)
    stops=[train.beginning_station]+ train.stops
    puts "--------------------------------------------------------------"
    puts "#{train.beginning_station.include?(from_station)}"
    puts "#{train.beginning_station}"
    puts "#{from_station}"
    if train.beginning_station.include?(from_station) && stops.include?(destination_station) 
        return true
    else 
        return false
    end
    if stops.include?(from_station) &&  stops.index(from_station) < stops.include?(destination_station) 
        return true
    else
        return false
    end
end
  

end