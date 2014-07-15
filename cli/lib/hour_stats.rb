#!/usr/bin/env ruby

class HourStats < StatsBase

  def initialize
    super()
    # create the week of days
    (0..23).each do |hour|
      @data["#{hour}"] = Hour.new(hour)
    end
  end

  def get_charting_data(chart_value)
    super("display_hour",chart_value)
  end
end
