.PHONY: test

install:
	gem install bundler && \
		bundle install

test:
	ruby ./tests/app_test.rb

run:
	bundle exec rackup
