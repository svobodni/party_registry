Sidekiq.configure_server do |config|
  config.redis = {
    url: 'redis://localhost:6379/3',
    namespace: 'svobodni_registr'
  }
end

Sidekiq.configure_client do |config|
  config.redis = {
    url: 'redis://localhost:6379/3',
    namespace: 'svobodni_registr'
  }
end

#Sidekiq::Cron::Job.load_from_hash YAML.load_file("config/schedule.yml")
