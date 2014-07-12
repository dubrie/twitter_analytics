#!/usr/bin/env ruby

require 'csv'
require 'date'
require 'time'

require './lib/tweet'
require './lib/day'
require './lib/day_stats'
require './lib/ascii_chart'

tweet_file = 'tweet_activity_metrics.csv'

# 2014-07-11 21:34 +0000
date_format = '%Y-%m-%d %H:%M %z'

days = DayStats.new

tweets = []
engagements = 0
impressions = 0

hours_of_day = {}

CSV.foreach(tweet_file, :headers => true) do |row|
    tweets << row

    tweet = Tweet.new(row)

    tweet_time = DateTime.strptime(row['time'], date_format).to_time.getlocal
    num_engagements = row['engagements'].to_i
    num_impressions = row['impressions'].to_i

    tweet_data = {
        :text => row['Tweet text'],
        :date => tweet_time,
        :impressions => num_impressions,
        :engagements => num_engagements,
        :permalink => row['Tweet permalink'],
        :retweets => row['retweets'].to_i,
        :replies => row['replies'].to_i,
        :favorites => row['favorites'].to_i,
        :profile_clicks => row['user profile clicks'].to_i,
        :url_clicks => row['url clicks'].to_i,
        :hashtag_clicks => row['hashtag clicks'].to_i,
        :detail_clicks => row['detail expands'].to_i        
    }

    days.add_tweet(tweet_time.wday, tweet)

    if !hours_of_day.has_key?(tweet_time.hour)
        hours_of_day[tweet_time.hour] = []
    end

    hours_of_day[tweet_time.hour] << tweet_data

    engagements += num_engagements
    impressions += num_impressions
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

chart = AsciiChart.new(days.tweets_per_day_hash)
chart.title = "Tweets by Day"
chart.legend = "Tweets"
chart.scale_factor = days.scale_factor

chart.render

puts ""
puts "----------------------------------------------"
puts "HOUR BREAKDOWN"
hourly_engagements = {}
hourly_impressions = {}

hours_of_day.keys.sort!
hours_of_day.sort.map do |idx, hour|
    puts "Hour #{idx}"
    puts "    tweets: #{hour.size}"
    hTweets = hour.size
    hEngagements = 0
    hImpressions = 0
    hour.each do |tweet|
        # Calculate engagement/impressions for this hour of the day
        hEngagements += tweet[:engagements]
        hImpressions += tweet[:impressions]
    end
    puts "    engagements: #{hEngagements} (#{hEngagements/hTweets}/tweet)"
    puts "    impressions: #{hImpressions} (#{hImpressions/hTweets}/tweet)"

    hourly_engagements["#{idx}"] = {
        :rate => hEngagements/hTweets,
        :total => hEngagements,
        :tweets => hTweets,
        :percent_total => '%.2f' % ((hEngagements.to_f/engagements.to_f)*100)
    }

    hourly_impressions["#{idx}"] = {
        :rate => hImpressions/hTweets,
        :total => hImpressions,
        :tweets => hTweets,
        :percent_total => '%.2f' % ((hImpressions.to_f/impressions.to_f)*100)
    }

end
puts ""

puts "top 10 engagement hours"
hourly_engagements.sort_by{|hour,amt| amt[:rate]}.reverse.first(10).each do |idx, val|
    puts "  Hour #{idx} - #{val[:rate]}/tweet (#{val[:percent_total]}% total engagements)"
end
puts ""
puts "top 10 impression hours"
hourly_impressions.sort_by{|hour,amt| amt[:rate]}.reverse.first(10).each do |idx, val|
    puts "  Hour #{idx} - #{val[:rate]}/tweet (#{val[:percent_total]}% total impressions)"
end




