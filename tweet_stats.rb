#!/usr/bin/env ruby

require 'csv'
require 'date'
require 'time'

require './lib/tweet'
require './lib/day'
require './lib/hour'
require './lib/stats_base'
require './lib/day_stats'
require './lib/hour_stats'

require './lib/ascii_chart'

tweet_file = 'tweet_activity_metrics.csv'
days = DayStats.new
hours = HourStats.new

CSV.foreach(tweet_file, :headers => true) do |row|

    tweet = Tweet.new(row)

    days.add_tweet(tweet.date.wday, tweet)
    hours.add_tweet(tweet.date.hour, tweet)
end

puts ""
puts "----------------------------------------------"
puts "Tweets: #{days.total_tweets}"
puts "Dates: #{days.num_days} days (#{days.start_date} - #{days.end_date})"
puts "Total Impressions: #{days.total_impressions}"
puts "Total Engagements: #{days.total_engagements}"
puts "Impressions/Tweet: #{days.impressions_per_tweet}"
puts "engagements/Tweet: #{days.engagements_per_tweet}"
puts "----------------------------------------------"
puts ""
puts "----------------------------------------------"
puts "TOP TWEETS"
puts "Engagement: #{days.max_engagement_tweet.engagements}"
puts "  > #{days.max_engagement_tweet.date} - #{days.max_engagement_tweet.text}"
puts ""
puts "Impression: #{days.max_impression_tweet.impressions}"
puts "  > #{days.max_impression_tweet.date} - #{days.max_impression_tweet.text}"
puts ""
puts "----------------------------------------------"

chart = AsciiChart.new(days.get_charting_data("day_of_week", "total_tweets"))
chart.title = "Tweets by Day"
chart.legend = "Tweets"
chart.render

puts ""

chart = AsciiChart.new(hours.get_charting_data("display_hour", "total_tweets"))
chart.title = "Tweets by Hour"
chart.legend = "Tweets"
chart.render

puts ""

chart = AsciiChart.new(hours.get_charting_data("display_hour", "total_impressions"))
chart.title = "Impressions by Hour"
chart.legend = "Impressions"
chart.render

puts ""

#puts "top 10 engagement hours"
#hourly_engagements.sort_by{|hour,amt| amt[:rate]}.reverse.first(10).each do |idx, val|
#    puts "  Hour #{idx} - #{val[:rate]}/tweet (#{val[:percent_total]}% total engagements)"
#end
#puts ""
#puts "top 10 impression hours"
#hourly_impressions.sort_by{|hour,amt| amt[:rate]}.reverse.first(10).each do |idx, val|
#    puts "  Hour #{idx} - #{val[:rate]}/tweet (#{val[:percent_total]}% total impressions)"
#end

