#!/usr/bin/env ruby

class Hour < UnitBase

    attr_accessor :hour_of_day
    attr_accessor :display_hour   # display with AM/PM

    def initialize(hour)
        super()
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
    end
end