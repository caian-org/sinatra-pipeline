.PHONY: test

build:
	docker build -t sinatra-app .

install:
	gem install bundler && bundle install

test:
	ruby ./test/app_test.rb

run:
	bundle exec rackup
