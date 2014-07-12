#!/usr/bin/env ruby

class AsciiChart

    attr_accessor :title
    attr_accessor :legend
    attr_accessor :scale_factor
    attr_accessor :data

    ASCII_CHAR = "#"

    def initialize(chart_data)
        @data = chart_data
        @scale_factor = 1   # TODO: Make this dynamic based on the data
        @title = ''
        @legend = ''
    end

    def render()
        puts "#{@title}"
        puts "#{ASCII_CHAR} = #{@scale_factor} #{@legend}"
        @data.map do |label, value|
            puts "%3s %5d %s\n" % [label, value, ASCII_CHAR * (value / @scale_factor)]
        end
    end
end