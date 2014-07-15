class DayStats < StatsBase
  attr_accessor :start_date
  attr_accessor :end_date

  def initialize
    super()
    # create the week of days
    @data = {}
    (0..6).each do |day|
        @data["#{day}"] = Day.new(day)
    end

    @start_date = nil
    @end_date = nil
  end

  def display_start_date
    @start_date.to_formatted_s(:short)
  end

  def display_end_date
    @end_date.to_formatted_s(:short)
  end

  def add_tweet(key, tweet)
    super(key, tweet)

    if !@start_date || @start_date > tweet.date
        @start_date = tweet.date
    end

    if !@end_date || @end_date < tweet.date
        @end_date = tweet.date
    end
  end

  def get_charting_data(chart_value)
    super("day_of_week",chart_value)
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

        ret_hash[@days["#{daynum}"]] = @days["#{daynum}"].total_tweets
    end

    ret_hash
  end
end
