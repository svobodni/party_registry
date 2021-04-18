require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module PartyRegistry
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :cs

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'

        resource '/auth/token',
        :headers => :any,
        :methods => [:get],
        :credentials => true,
        :max_age => 0

        resource '/people/*/private.json',
        :headers => :any,
        :methods => [:get],
        :credentials => true,
        :max_age => 0

      end
    end

    config.to_prepare do
      Devise::SessionsController.layout "session"
    end

    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
