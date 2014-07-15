class UnitBase
  attr_accessor :total_tweets
  attr_accessor :total_engagements
  attr_accessor :total_impressions

  attr_accessor :tweets

  def initialize()
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
