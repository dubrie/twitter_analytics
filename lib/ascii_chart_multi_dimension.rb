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
    attr_accessor :as_values
    attr_accessor :column_width

    DIMENSIONS = 3
    MIN_SCALE_FACTOR = 1

    def initialize(chart_data)
        super(chart_data)
        @data = chart_data
        @max_value = 0
        @min_value = 9999999999999
        set_scale_factor
        @title = ''
        @legend = ''
        @as_values = false
        @column_width = 6
    end

    def set_scale_factor
        @data.map do |label, value|
            @max_value = [value, @max_value].max
            @min_value = [value, @min_value].min 
        end

        @scale_factor = [(@max_value - @min_value)/ DIMENSIONS, MIN_SCALE_FACTOR].max
    end

    def get_row_def(column_type='s')
        col_def = "%#{@column_width}#{column_type}"
        headers = ["%#{@column_width}s"]
        24.times {headers << col_def}

        headers.join(" ")
    end

    def render()
        puts "#{@title}"
        prev_day = nil
        display_array = []
        header_vals = [" "].concat( (0..23).to_a)

        puts get_row_def('d') % header_vals

        @data.map do |label, value|
            key_parts = label.split(',')
            if !prev_day 
                prev_day = key_parts[0]
                display_array << key_parts[0]
            end

            if prev_day != key_parts[0]
                puts get_row_def % display_array.to_a
                display_array = [key_parts[0]]
            end

            if @as_values
                display_array << value
            else
                case (value / @scale_factor)
                    when 0
                        char = ""
                    when 1
                        char = "."
                    when 2 
                        char = "o"
                    when 3 
                        char = "O"
                    when 4 
                        char = "0"
                    else
                        char = "!"
                end
                display_array << char
            end

            prev_day = key_parts[0]
        end
    end
end