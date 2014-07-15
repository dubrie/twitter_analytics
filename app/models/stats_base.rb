class StatsBase

  attr_accessor :data

  attr_accessor :total_tweets
  attr_accessor :total_engagements
  attr_accessor :total_impressions

  attr_accessor :max_engagement_tweet
  attr_accessor :max_impression_tweet

  def initialize
    @data = {}

    @total_tweets = 0
    @total_engagements = 0
    @total_impressions = 0

    @max_engagement_tweet = nil
    @max_impression_tweet = nil
  end

  def add_tweet(key, tweet)
    @total_tweets += 1
    @total_impressions += tweet.impressions
    @total_engagements += tweet.engagements

    @max_impression_tweet = (!@max_impression_tweet || @max_impression_tweet.impressions < tweet.impressions) ? tweet : @max_impression_tweet
    @max_engagement_tweet = (!@max_engagement_tweet || @max_engagement_tweet.engagements < tweet.engagements) ? tweet : @max_engagement_tweet

    @data["#{key}"].add_tweet(tweet)
  end

  def get_charting_data(display_column, chart_value)
    ret_hash = {}
    @data.keys.each do |key|
      obj = @data["#{key}"]
      ret_hash["#{obj.send(display_column)}"] = obj.send(chart_value)
    end

    ret_hash
  end

end
