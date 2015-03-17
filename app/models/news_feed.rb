class NewsFeed

  def self.items
    begin
      client = Twitter::REST::Client.new do |config|
        config.consumer_key        = configatron.twitter.consumer_key
        config.consumer_secret     = configatron.twitter.consumer_secret
        config.access_token        = configatron.twitter.access_token
        config.access_token_secret = configatron.twitter.access_token_secret
      end
      client.home_timeline
    rescue StandardError => e
      []
    end
  end

end
