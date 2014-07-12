#!/usr/bin/env ruby

class HourStats < StatsBase

  def initialize
    super()
    # create the week of days
    (0..23).each do |hour|
      @data["#{hour}"] = Hour.new(hour)
    end
  end

end
