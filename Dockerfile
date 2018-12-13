FROM ruby:2.5-alpine
WORKDIR /app

ADD Gemfile /app
ADD Gemfile.lock /app

ADD /src /app

RUN bundle install --system

EXPOSE 4567

CMD ["ruby", "app.rb"]
