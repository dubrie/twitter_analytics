#!/usr/bin/env ruby

class AsciiChartMultiDimension < AsciiChart

    attr_accessor :title
    attr_accessor :legend
    attr_accessor :scale_factor
    attr_accessor :data
    attr_accessor :max_value
    attr_accessor :min_value
    attr_accessor :x_axis
    attr_accessor :y_axis

    CHART_WIDTH = 40  # in columns
    COLUMN_WIDTH = 5
    NUM_COLUMNS = 24
    MIN_SCALE_FACTOR = 1

    def initialize(chart_data)
        super(chart_data)
        @data = chart_data
        @max_value = 0
        @min_value = 9999999999999
        set_scale_factor
        @title = ''
        @legend = ''
    end

    def set_scale_factor
        @data.map do |label, value|
            @max_value = [value, @max_value].max
            @min_value = [value, @min_value].min 
        end

        @scale_factor = [(@max_value - @min_value)/ CHART_WIDTH, MIN_SCALE_FACTOR].max
    end

    def render()
        puts "#{@title}"
        prev_day = nil
        display_array = []
        puts "      %5d %5d %5d %5d %5d %5d %5d %5d %5d %5d %5d %5d %5d %5d %5d %5d %5d %5d %5d %5d %5d %5d %5d %5d \n" % (0..23).to_a

        @data.map do |label, value|
            key_parts = label.split(',')
            if !prev_day 
                prev_day = key_parts[0]
                display_array << key_parts[0]
            end

            if prev_day != key_parts[0]
                puts "%5s %5d %5d %5d %5d %5d %5d %5d %5d %5d %5d %5d %5d %5d %5d %5d %5d %5d %5d %5d %5d %5d %5d %5d %5d \n" % display_array.to_a
                display_array = [key_parts[0]]
            end
            display_array << value

            prev_day = key_parts[0]
        end
    end
end