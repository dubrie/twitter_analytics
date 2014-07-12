#!/usr/bin/env ruby

class Day

  attr_accessor :day_of_week
  attr_accessor :day_number
  attr_accessor :total_tweets
  attr_accessor :total_engagements
  attr_accessor :total_impressions

  attr_accessor :tweets

  def initialize(day_number)
        @day_number = day_number
        case @day_number
            when 0
                @day_of_week = 'SUN'
            when 1
                @day_of_week = 'MON'
            when 2
                @day_of_week = 'TUE'
            when 3
                @day_of_week = 'WED'
            when 4
                @day_of_week = 'THU'
            when 5
                @day_of_week = 'FRI'
            when 6
                @day_of_week = 'SAT'
        end

        @tweets = []
        @total_tweets = 0
        @total_engagements = 0
        @total_impressions = 0
  end       

  def add_tweet(tweet)
    @tweets << tweet
    @total_tweets += 1
    @total_impressions += tweet.impressions
    @total_engagements += tweet.engagements
  end

end