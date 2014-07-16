class Tweet
    
    attr_accessor :text
    attr_accessor :date
    attr_accessor :impressions
    attr_accessor :engagements
    attr_accessor :permalink
    attr_accessor :retweets
    attr_accessor :replies
    attr_accessor :favorites
    attr_accessor :profile_clicks
    attr_accessor :url_clicks
    attr_accessor :hashtag_clicks
    attr_accessor :detail_clicks

    DATE_FORMAT = "%Y-%m-%d %H:%M %z"

    def initialize(data=nil)
        if data
            @text = data['Tweet text']
            @date = DateTime.strptime(data['time'], DATE_FORMAT).to_time.getlocal
            @impressions = data['impressions'].to_i
            @engagements = data['engagements'].to_i
            @permalink = data['Tweet permalink']
            @retweets = data['retweets'].to_i
            @replies = data['replies'].to_i
            @favorites = data['favorites'].to_i
            @profile_clicks = data['user profile clicks'].to_i
            @url_clicks = data['url clicks'].to_i
            @hashtag_clicks = data['hashtag clicks'].to_i
            @detail_clicks = data['detail expands'].to_i
        end
    end

end
