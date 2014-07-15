require 'csv'
require 'json'

class UploadController < ApplicationController
    def index
    end

    def parse
        tweet_file = params[:file]

        @days = DayStats.new
        CSV.foreach(tweet_file.path, :headers => true) do |row|
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
        @chart.title = "Weekly Points In Time"
        @chart.find_optimal_value
        @top_time = @chart.convert_key_to_display_date(@chart.optimal_posting_time)

        random_string = (0...16).map { (65 + rand(26)).chr }.join
        @stats_file = "tweet-stats-#{random_string}.csv"
        target = "public/#{@stats_file}"
        File.open(target, "w+") do |f|
          f.write(@chart.as_csv)
        end

    end
end
