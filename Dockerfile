FROM ruby:2.5-alpine
WORKDIR /app

RUN apk add --update \
  build-base \
  postgresql-dev \
  && rm -rf /var/cache/apk/*

ADD Gemfile /app
ADD Gemfile.lock /app

ADD /src /app

RUN bundle install --system

EXPOSE 4567

CMD ["ruby", "app.rb"]
