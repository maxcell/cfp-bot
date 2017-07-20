require 'twitter'

class TwitterScraper

  def initialize(name, since_id = nil)
    @name = name
    @since_id = since_id
  end

  
  def self.client
    @@client ||= Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV.fetch('CONSUMER_KEY')
      config.consumer_secret     = ENV.fetch('CONSUMER_SECRET')
      config.access_token        = ENV.fetch('ACCESS_TOKEN')
      config.access_token_secret = ENV.fetch('ACCESS_TOKEN_SECRET')
    end
  end

  def tweets
    opts = {}
    opts[:since_id] = @since_id if @since_id

    self.class.client.user_timeline(@name, opts)
  end
end
