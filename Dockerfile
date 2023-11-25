FROM ruby:3.1.2 as base

RUN apt-get update -qq && apt-get install -y build-essential apt-utils libpq-dev

WORKDIR /docker/app

RUN gem install bundler

COPY Gemfile* ./

RUN bundle install

ADD . /docker/app

ARG DEFAULT_PORT 3000

EXPOSE ${DEFAULT_PORT}

CMD ["rails", "server"]