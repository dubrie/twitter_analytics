#!/usr/bin/env ruby

require 'csv'
require 'date'
require 'time'

require './lib/tweet'
require './lib/unit_base'
require './lib/day'
require './lib/hour'
require './lib/multi_dimension'
require './lib/stats_base'
require './lib/day_stats'
require './lib/hour_stats'
require './lib/multi_dimension_stats'

require './lib/ascii_chart'
require './lib/ascii_chart_multi_dimension'

tweet_file = 'tweet_activity_metrics.csv'

days = DayStats.new
hours = HourStats.new

CSV.foreach(tweet_file, :headers => true) do |row|

    tweet = Tweet.new(row)

    days.add_tweet(tweet.date.wday, tweet)
    hours.add_tweet(tweet.date.hour, tweet)
end

chart_data = MultiDimensionStats.new()
days.data.each do |num,day|
    day.tweets.sort_by{|tweet| tweet.date}.each do |record|
        chart_data.data["#{num},#{record.date.hour}"].add_tweet(record)
    end
end

chart = AsciiChartMultiDimension.new(chart_data.get_charting_data("total_impressions"))
chart.title = "Weekly Points In Time"
chart.legend = "Impressions"
chart.render
