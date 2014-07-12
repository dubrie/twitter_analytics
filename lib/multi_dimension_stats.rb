#!/usr/bin/env ruby

class MultiDimensionStats < StatsBase

  def initialize
    super()
    # create the week of days
    (0..6).each do |day|
      (0..23).each do |hour|
        @data["#{day},#{hour}"] = MultiDimension.new(day,hour)
      end
    end
  end

  def get_charting_data(chart_value)
    super("display_key",chart_value)
  end
end
