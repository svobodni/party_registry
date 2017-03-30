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
    rake db:create
```

* Database initialization
```
    rake db:migrate
    rake db:seed
```

* How to run the test suite
```
    rake
```

* Development instructions
```
    rake db:populate
```

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions
