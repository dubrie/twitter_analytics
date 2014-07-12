#!/usr/bin/env ruby

class DayStats 

  attr_accessor :days
  attr_accessor :start_date
  attr_accessor :end_date
  attr_accessor :total_tweets
  attr_accessor :total_engagements
  attr_accessor :total_impressions

  attr_accessor :max_engagement_tweet
  attr_accessor :max_impression_tweet

  CHART_WIDTH = 30  # in columns
  MIN_SCALE_FACTOR = 1

  def initialize
    # create the week of days
    @days = {
        '0' => Day.new(0),
        '1' => Day.new(1),
        '2' => Day.new(2),
        '3' => Day.new(3),
        '4' => Day.new(4),
        '5' => Day.new(5),
        '6' => Day.new(6)
    }

    @start_date = nil
    @end_date = nil

    @total_tweets = 0
    @total_engagements = 0
    @total_impressions = 0

    @max_engagement_tweet = nil
    @max_impression_tweet = nil
  end

  def add_tweet(day_num, tweet)
    if !@start_date || @start_date > tweet.date
        @start_date = tweet.date
    end

    if !@end_date || @end_date < tweet.date
        @end_date = tweet.date
    end

    @total_tweets += 1
    @total_impressions += tweet.impressions
    @total_engagements += tweet.engagements

    @max_impression_tweet = (!@max_impression_tweet || @max_impression_tweet.impressions < tweet.impressions) ? tweet : @max_impression_tweet
    @max_engagement_tweet = (!@max_engagement_tweet || @max_engagement_tweet.engagements < tweet.engagements) ? tweet : @max_engagement_tweet

    @days["#{day_num}"].add_tweet(tweet)
  end

  def max_tweet_day
    max = 0
    @days.values.each do |day|
        max = [day.total_tweets, max].max
    end

    max
  end

  def min_tweet_day
    min = max_tweet_day
    @days.values.each do |day|
        min = [day.total_tweets, min].min
    end

    min
  end

  def scale_factor
    scale_factor = (max_tweet_day - min_tweet_day)/ CHART_WIDTH
    [scale_factor, MIN_SCALE_FACTOR].max
  end

  def num_days
    ((@end_date - @start_date)/86400).to_i
  end

  def impressions_per_tweet
    @total_impressions/@total_tweets
  end

  def engagements_per_tweet
    @total_engagements/@total_tweets
  end

  def tweets_per_day_hash
    ret_hash = {}
    @days.keys.sort.each do |daynum|

        ret_hash[@days["#{daynum}"].day_of_week] = @days["#{daynum}"].total_tweets
    end

    ret_hash
  end

end