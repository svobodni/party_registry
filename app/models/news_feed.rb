class NewsFeed

  def self.items
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = "mG3Bni2iKZv70UkzeZwFZjVPu"
      config.consumer_secret     = "YNl25W1vzlmNHUWLzfKfKWVTiZYRskby5D8dbGvyueukpEu3k9"
      config.access_token        = "3072281596-MEipY28e9A4lUKuaH23PNQ00Vhcm9fBh0pUNCEB"
      config.access_token_secret = "kGIHmBjIdTPcWwDR36hZQzS8LjBsyM77611EL29QX6tPL"
    end
    client.home_timeline
  end

end
