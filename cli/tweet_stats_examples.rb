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

chart = AsciiChart.new(days.get_charting_data("total_tweets"))
chart.title = "Tweets by Day"
chart.legend = "Tweets"
chart.render

puts ""

chart = AsciiChart.new(days.get_charting_data("total_impressions"))
chart.title = "Top Days for Impressions"
chart.legend = "Impressions"
chart.render

puts ""

chart = AsciiChart.new(days.get_charting_data("total_engagements"))
chart.title = "Top Days for Engagements"
chart.legend = "Engagements"
chart.render

puts ""

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
puts "  > #{days.max_engagement_tweet.date} - #{days.max_engagement_tweet.text} #{days.max_engagement_tweet.permalink}"
puts ""
puts "Impression: #{days.max_impression_tweet.impressions}"
puts "  > #{days.max_impression_tweet.date} - #{days.max_impression_tweet.text} #{days.max_impression_tweet.permalink}"
puts ""
puts "----------------------------------------------"

chart = AsciiChart.new(hours.get_charting_data("total_tweets"))
chart.title = "Tweets by Hour"
chart.legend = "Tweets"
chart.render

puts ""

chart = AsciiChart.new(hours.get_charting_data("total_impressions"))
chart.title = "Top Hours for Impressions"
chart.legend = "Impressions"
chart.render

puts ""

chart = AsciiChart.new(hours.get_charting_data("total_engagements"))
chart.title = "Top Hours for Engagements"
chart.legend = "Engagements"
chart.render

puts ""

puts "Top 3 engagement hours"
hours.data.sort_by{|hour,amt| amt.total_engagements}.reverse.first(3).each do |idx, val|
    percent_total = '%.2f' % ((val.total_engagements.to_f/hours.total_engagements.to_f)*100)
    puts "  Hour #{idx} - #{val.total_engagements}/tweet (#{percent_total}% total)"
end
puts ""
puts "Top 3 impression hours"
hours.data.sort_by{|hour,amt| amt.total_impressions}.reverse.first(3).each do |idx, val|
    percent_total = '%.2f' % ((val.total_impressions.to_f/hours.total_impressions.to_f)*100)
    puts "  Hour #{idx} - #{val.total_impressions}/tweet (#{percent_total}% total)"
end

puts "Number of Tweets By Day/Hour"
chart_data = MultiDimensionStats.new()
days.data.each do |num,day|
    day.tweets.sort_by{|tweet| tweet.date}.each do |record|
        chart_data.data["#{num},#{record.date.hour}"].add_tweet(record)
    end
end

puts "Top 10 Tweeting times of week"
chart_data.data.sort_by{|key,tweet| tweet.total_tweets}.reverse.first(10).each do |idx, val|
    percent_total = '%.2f' % ((val.total_tweets.to_f/days.total_tweets.to_f)*100)
    puts "  #{val.display_key} - #{val.total_tweets} (#{percent_total}% total)"
end

puts "Top 10 Impressions times of week"
chart_data.data.sort_by{|key,tweet| tweet.total_impressions}.reverse.first(10).each do |idx, val|
    percent_total = '%.2f' % ((val.total_impressions.to_f/days.total_impressions.to_f)*100)
    puts "  #{val.display_key} - #{val.total_impressions/val.total_tweets}/tweet (#{percent_total}% total)"
end

puts "Top 10 Engagement times of week"
chart_data.data.sort_by{|key,tweet| tweet.total_engagements}.reverse.first(10).each do |idx, val|
    percent_total = '%.2f' % ((val.total_engagements.to_f/days.total_engagements.to_f)*100)
    puts "  #{val.display_key} - #{val.total_engagements/val.total_tweets}/tweet (#{percent_total}% total)"
end



chart = AsciiChartMultiDimension.new(chart_data.get_charting_data("total_impressions"))
chart.title = "Weekly Points In Time"
chart.legend = "Impressions"
chart.render



