require 'twitter'

class TwitterScraper
  def self.client
    @@client ||= Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV.fetch('TWITTER_CONSUMER_KEY')
      config.consumer_secret     = ENV.fetch('TWITTER_CONSUMER_SECRET')
      config.access_token        = ENV.fetch('TWITTER_ACCESS_TOKEN')
      config.access_token_secret = ENV.fetch('TWITTER_ACCESS_TOKEN_SECRET')
    end
  end

  def initialize(name, since_id = nil)
    @name = name
    @since_id = since_id
  end

  def client
    self.class.client
  end

  def tweets
    opts = {}
    opts[:since_id] = @since_id if @since_id

    client.user_timeline(@name, opts)
  end
end
