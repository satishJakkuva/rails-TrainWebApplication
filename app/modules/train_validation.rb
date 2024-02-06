module TrainValidation
    include InvalidConstants
    def validate_train(train)
        errors=[]
        errors << INVALID_TRAIN_NUMBER unless validate_train_number(train.train_number)
        errors <<  INVALID_BEGINNING_STATION unless validate_beginning_station(train.beginning_station)
        errors <<  INVALID_DESTINATION_STATION unless validate_destination_station(train.destination_station)
        errors <<  BLANK_TRAIN_NAME unless validate_train_name(train.train_name)
        errors <<  INVALID_START_TIME_FORMAT unless validate_start_time_format(train.start_time)
        errors <<  INVALID_END_TIME_FORMAT unless validate_end_time_format(train.end_time)
        errors <<  INVALID_STOPS unless validate_price_for_stop(train.stops,train.price_for_stop)

        errors
    end

    private
    def validate_train_number(train_number)
        unless train_number.match?(/\A\d{5}\z/)
          return false
        end
        true
    end
    def validate_beginning_station(station)
        unless station.match?(/\A[A-Za-z]+\z/)
          return false
        end
        true
    end
    def validate_destination_station(station)
      unless station.match?(/\A[A-Za-z]+\z/)
         return false
        end
         true
    end  
    def validate_train_name(train_name)
      unless train_name.empty?
        return true
      end
        false
    end
    def validate_start_time_format(start_time)
      unless start_time.is_a?(DateTime)
        return false
      end
        true
    end
    def validate_end_time_format(end_time)
        unless end_time.is_a?(DateTime)
            return false
        end
          true
    end   
   
    def validate_price_for_stop(stops, price_for_stop)
      return true if stops.blank? || price_for_stop.blank?
      missing_stops = stops - price_for_stop.keys
      if missing_stops.empty?
        true
      else
        false
      end
    end
      
      
end