FROM ruby:2.7.3

RUN apt-get update -qq && apt-get install -y mariadb-client npm --no-install-recommends
RUN npm install --global yarn

RUN mkdir /myapp
WORKDIR /myapp

COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock

RUN bundle install

COPY . /myapp

#RUN bin/rails assets:precompile
CMD "/myapp/docker-entrypoint.sh"
