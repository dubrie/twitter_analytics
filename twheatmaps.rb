# twheatmaps.rb
require 'erubis'
require 'csv'
require 'time'
require 'date'

set :root, File.dirname(__FILE__)

require './lib/unit_base'
require './lib/stats_base'
require './lib/ascii_chart'

configure do
  $LOAD_PATH.unshift("#{File.dirname(__FILE__)}/lib")
  Dir.glob("#{File.dirname(__FILE__)}/lib/*.rb") { |lib| 
    require File.basename(lib, '.*') 
  }
end

class Twheatmaps < Sinatra::Base

    get '/' do
        erb :uploader, :locals => {} 
    end

    post '/parse' do
        if !params[:file][:tempfile]
            redirect '/' 
        else

            tweet_file = params[:file][:tempfile]

            @days = DayStats.new
            CSV.foreach(tweet_file, :headers => true) do |row|
                tweet = Tweet.new(row)
                @days.add_tweet(tweet.date.wday, tweet)
            end

            @chart_data = MultiDimensionStats.new()
            @days.data.each do |num,day|
                day.tweets.sort_by{|tweet| tweet.date}.each do |record|
                    @chart_data.data["#{num},#{record.date.hour}"].add_tweet(record)
                end
            end

            @chart = AsciiChartMultiDimension.new(@chart_data.get_charting_data("total_impressions"))
            @chart.as_values = true
            @chart.find_optimal_value
            @top_time = @chart.convert_key_to_display_date(@chart.optimal_posting_time)

            random_string = (0...16).map { (65 + rand(26)).chr }.join
            @stats_file = "tweet-stats-#{random_string}.csv"
            target = "public/#{@stats_file}"
            File.open(target, "w+") do |f|
                f.write(@chart.as_csv)
            end

            erb :parse, :locals => {
                :days => @days, 
                :formatted_start => @days.display_start_date,
                :formatted_end => @days.display_end_date,
                :stats_file => @stats_file, 
                :top_time => @top_time
            } 
        end
    end


end