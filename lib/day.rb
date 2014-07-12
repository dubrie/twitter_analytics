#!/usr/bin/env ruby

class Day < UnitBase

    attr_accessor :day_of_week
    attr_accessor :day_number

    def initialize(day_number)
        super()

        @day_number = day_number
        case @day_number
            when 0
                @day_of_week = 'SUN'
            when 1
                @day_of_week = 'MON'
            when 2
                @day_of_week = 'TUE'
            when 3
                @day_of_week = 'WED'
            when 4
                @day_of_week = 'THU'
            when 5
                @day_of_week = 'FRI'
            when 6
                @day_of_week = 'SAT'
        end
    end       
end