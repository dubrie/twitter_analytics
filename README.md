twitter_analytics
=================

A crude but deeper dive into the Twitter analytics data available at https://analytics.twitter.com. This repo supports creating of charts based on your Twitter analytics export data file.

Usage
=====
The code base consists of multiple classes in the /lib path to help process the data and a tweet_stats.rb file to parse the CSV and print out a chart on the command line.  To use the script, copy the `tweet_activity_metrics.csv` export from the Twitter analytics dashboard into the root path of the repo and run:

    ruby tweet_stats.rb
    
Charts
======
You can produce multiple types of charts for your Twitter data including:

* Top Tweets - Your most engaged and most viewed tweets
* Total Tweets - Your total number of tweets by day of the week or by hour
* Total Engagements - The total number of engagements by day of the week or by hour
* Total Impressions - The total number of impressions by day of the week or by hour
* Top Engagement Hours - The top n tweeting hours for engagement
* Top Impression Hours - Top top n tweeting hours for impressions
* Top Engagement Time of Day Combinations - The top n time of day combinations (ex: MON at 1pm) with the most engagements
* Top Impression Time of Day Combinations - The top n time of day combinations (ex: SUN at 7am) with the most impressions
* Time of Day Engagement Matrix - Engagement values for every time of day/day of week combination
* Time of Day Impression Matrix - Impression values for every time of day/day of week combination

