require 'csv'
require 'date'
require 'time'

tweet_file = 'tweet_activity_metrics.csv'

# 2014-07-11 21:34 +0000
date_format = '%Y-%m-%d %H:%M %z'

days = {
    '0' => "Sun",
    '1' => "Mon",
    '2' => "Tue",
    '3' => "Wed",
    '4' => "Thu",
    '5' => "Fri",
    '6' => "Sat"
}

tweets = []
engagements = 0
impressions = 0

max_engagement = 0
max_engagement_tweet = nil
max_impression = 0
max_impression_tweet = nil

hours_of_day = {}
days_of_week = {}

# Pick some date way in the future
min_date = DateTime.strptime("2222-01-01 00:00 +0000", date_format).to_time.getlocal
# Just take the epoch date
max_date = DateTime.strptime("1970-01-01 00:00 +0000", date_format).to_time.getlocal

CSV.foreach(tweet_file, :headers => true) do |row|
    tweets << row
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

    if !days_of_week.has_key?(tweet_time.wday)
        days_of_week[tweet_time.wday] = []
    end

    days_of_week[tweet_time.wday] << tweet_data

    if !hours_of_day.has_key?(tweet_time.hour)
        hours_of_day[tweet_time.hour] = []
    end

    hours_of_day[tweet_time.hour] << tweet_data

    if tweet_time < min_date
        min_date = tweet_time
    end

    if max_date < tweet_time
        max_date = tweet_time
    end

    engagements += num_engagements

    if num_engagements > max_engagement
        max_engagement = num_engagements
        max_engagement_tweet = row
        max_engagement_tweet['time'] = tweet_time
    end
  
    impressions += num_impressions

    if num_impressions > max_impression
        max_impression = num_impressions
        max_impression_tweet = row
        max_impression_tweet['time'] = tweet_time
    end
end

puts "Tweet Range: #{min_date} -- #{max_date}"
puts "Tweets: #{tweets.size}"
puts "Total Impressions: #{impressions}"
puts "Total Engagements: #{engagements}"
puts "Impressions/Tweet: #{impressions/tweets.size}"
puts "engagements/Tweet: #{engagements/tweets.size}"

puts "max engagement: #{max_engagement}"
puts "  > #{max_engagement_tweet['time']} - #{max_engagement_tweet['Tweet text']}"
puts ""
puts "max impression: #{max_impression}"
puts "  > #{max_impression_tweet['time']} - #{max_impression_tweet['Tweet text']}"
puts ""

# TODO: Make this a chart instead of just text
puts "DAY BREAKDOWN"
days_of_week.keys.sort!
days_of_week.sort.map do |idx, day|
    dow = days["#{idx}"]
    puts "#{dow}) total tweets: #{day.size}"
    prevDay = idx.to_i+1
end
puts ""

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




