#!/usr/bin/env ruby

class Hour

  attr_accessor :hour_of_day
  attr_accessor :display_hour   # display with AM/PM

  attr_accessor :total_tweets
  attr_accessor :total_engagements
  attr_accessor :total_impressions

  attr_accessor :tweets

  def initialize(hour)
        @hour_of_day = hour
        case @hour_of_day 
            when 0
                @display_hour = "12am"
            when 1..11
                @display_hour = "#{@hour_of_day}am"
            when 12
                @display_hour = "12pm"
            else 
                @display_hour = "#{((@hour_of_day).to_i)-12}pm"
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