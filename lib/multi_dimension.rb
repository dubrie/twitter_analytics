class MultiDimension < Day

    attr_accessor :hour_of_day
    attr_accessor :display_hour   # display with AM/PM

    attr_accessor :display_key

    def initialize(day, hour)
        super(day)

        @hour_of_day = hour
        case @hour_of_day 
            when 0
                @display_hour = "12am"
            when 1..11
                @display_hour = "#{@hour_of_day}am"
            when 12
                @display_hour = "12pm"
            else 
                @display_hour = "#{((@hour_of_day).to_i)-12}pm"
        end

        @display_key = "#{@day_number},#{@hour_of_day}"

    end       
end