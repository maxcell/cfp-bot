require 'redis'
require 'slack-ruby-client'

require_relative './lib/twitter_scraper'

redis = Redis.new

techspeakdigest = TwitterScraper.new('techspeakdigest', redis.get('techspeakdigest_latest'))

techspeakdigest_tweets = techspeakdigest.tweets

techspeakdigest_cfps = techspeakdigest_tweets.map do |tweet|
  if tweet.uris.first
    url = tweet.uris.first.expanded_url.to_s
    tweet.text if /tinyletter/.match(url)
  end
end.compact

redis.set('techspeakdigest_latest', techspeakdigest_tweets.first.id) unless techspeakdigest_tweets.empty?

mozillatech = TwitterScraper.new('mozTechCFPs', redis.get('mozillatech_latest'))

mozillatech_tweets = mozillatech.tweets

mozillatech_cfps = mozillatech_tweets.map do |tweet|
  tweet.text if /cfp/i.match(tweet.text)
end.compact

redis.set('mozillatech_latest', mozillatech_tweets.first.id) unless mozillatech_tweets.empty?

cfps = techspeakdigest_cfps + mozillatech_cfps
p cfps

client = Slack::Web::Client.new(token: ENV.fetch('SLACK_API_TOKEN'))
cfps.each do |cfp|
  client.chat_postMessage(channel: '@eddie', text: cfp, as_user: true)
end
