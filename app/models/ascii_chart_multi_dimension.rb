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
    attr_accessor :days
    attr_accessor :times
    attr_accessor :optimal_posting_time

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

    def convert_key_to_display_date(key)
        key_parts = key.split(',')
        day = Day.new(key_parts[0].to_i)
        hour = Hour.new(key_parts[1].to_i)

        "#{day.day_of_week} #{hour.display_hour}"
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

    def find_optimal_value
        max_val = 0
        @data.map do |label, value|
            if value > max_val
                max_val = value
                @optimal_posting_time = "#{label}"
            end
        end
    end

    def as_json()
        display_obj = []

        @data.map do |label, value|
            key_parts = label.split(',')
            display_obj << {
                "day" => key_parts[0].to_i,
                "hour" => key_parts[1].to_i,
                "value" => value
            }
        end

        display_obj.to_json
    end

    def as_csv(headers=true)
        display_array = []
        if headers 
            display_array << ["day","hour","value"]
        end
        
        @data.map do |label, value|
            key_parts = label.split(',')
            display_array << ["#{key_parts[0]}","#{key_parts[1]}",value]
        end

        csv_string = CSV.generate do |csv|
            display_array.each { |i| csv << i }
        end

        csv_string
    end

    def render(echo=false)
        if echo
            puts "#{@title}"
        end

        prev_day = nil
        display_array = []
        header_vals = [" "].concat( (0..23).to_a)

        if echo 
            puts get_row_def('d') % header_vals
        end

        @data.map do |label, value|
            key_parts = label.split(',')
            if !prev_day 
                prev_day = key_parts[0]
                display_array << key_parts[0]
            end

            if prev_day != key_parts[0]
                if echo
                    puts get_row_def % display_array.to_a
                end
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

        if echo 
            puts get_row_def % display_array.to_a
        else
            return display_array.to_a
        end

    end
end