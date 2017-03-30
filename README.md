Political party registry
========================

[![Build Status](https://travis-ci.org/svobodni/party_registry.svg?branch=master)](https://travis-ci.org/svobodni/party_registry)

* Ruby version

    2.1.0 + rubygems

* System dependencies
```
    gem install bundler
```

* Configuration
```
    bundle install
    cp config/configatron/development.example.rb config/configatron/development.rb
```

* Database creation
```
    bundle exec rake db:create
```

* Database initialization
```
    bundle exec rake db:migrate
    bundle exec rake db:seed
```

* How to run the test suite
```
    bundle exec rake
```

* Development instructions
```
    bundle exec rake db:populate
```

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions
