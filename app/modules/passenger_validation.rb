module PassengerValidation
    include InvalidConstants
    def validate_passenger(passenger)
        errors=[]
        errors << INVALID_PHONE unless validate_phone_number(passenger.phone)
        errors << INVALID_GENDER unless validate_gender(passenger.gender)
        errors << INVALID_EMAIL unless validate_email(passenger.email)
        errors << INVALID_NAME  unless validate_name(passenger.name)
        errors << INVALID_AGE   unless validate_age(passenger.age)
        errors
    end
    private
    def validate_gender(gender)
        valid_genders = ['male', 'female', 'other']
        unless valid_genders.include?(gender.downcase)
          return false
        end
        true
    end
    def validate_name(name)
        if name.match?(/\A [A-Za-z]\Z/) && !name.blank?
            return false
        else
            true
        end      
    end
    def validate_phone_number(phone)
      existing_record=Passenger.find_by(phone:phone)
        unless phone.match?(/\A\d{10}\z/) && existing_record.empty?
          return false
        end
        true
    end
    def validate_email(email)
        email_regex = /\A[a-zA-Z]+[0-9]*@gmail\.com\z/
        if email.match?(email_regex)
          true  
        else
          false  
        end
    end
    def validate_age(age)
       if !age.blank? && age>0 && age<100
        return true
       else
        return false
       end
    end
      
      

end