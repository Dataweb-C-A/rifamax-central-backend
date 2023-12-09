FROM ruby:3.1.2

WORKDIR /app

COPY . .

RUN apt-get update -yqq \
  && apt-get install -yqq --no-install-recommends \
  postgresql-client nodejs \
  nano \
  && rm -rf /var/lib/apt/lists
ENV TZ=America/Caracas

RUN gem install bundler -v 2.4.17

RUN bundle install

ENV RAILS_ENV=development

# RUN bundle exec rails assets:precompile

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3000", "-e", "development"]