#!/bin/sh

bin/rake db:setup
bin/rake db:migrate
bin/rake db:populate
bundle exec rails s -p 3000 -b '0.0.0.0'
