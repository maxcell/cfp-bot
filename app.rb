require_relative './lib/twitter_scraper'

techspeakdigest = TwitterScraper.new('techspeakdigest')

techspeadigest_cfps = techspeakdigest.tweets.map do |tweet|
  if tweet.uris.first
    url = tweet.uris.first.expanded_url.to_s
    url if /tinyletter/.match(url)
  end
end.compact

mozillatech = TwitterScraper.new('mozTechCFPs')

mozillatech_cfps = mozillatech.tweets.map do |tweet|
  tweet.text if /cfp/i.match(tweet.text)
end.compact

p mozillatech_cfps
