FROM ruby:2.3.3

RUN apt-get update -qq && apt-get install -y build-essential libopencv-dev mysql-client nodejs --no-install-recommends

RUN mkdir /myapp
WORKDIR /myapp

COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock

RUN bundle install

COPY . /myapp

#RUN bin/rails assets:precompile
CMD "/myapp/docker-entrypoint.sh"
