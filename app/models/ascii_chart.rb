class AsciiChart

    attr_accessor :title
    attr_accessor :legend
    attr_accessor :scale_factor
    attr_accessor :data
    attr_accessor :max_value
    attr_accessor :min_value

    ASCII_CHAR = "#"
    CHART_WIDTH = 40  # in columns
    MIN_SCALE_FACTOR = 1

    def initialize(chart_data)
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
        puts "#{ASCII_CHAR} = #{@scale_factor} #{@legend}"
        @data.map do |label, value|
            puts "%5s %5d %s\n" % [label, value, ASCII_CHAR * (value / @scale_factor)]
        end
    end
end
