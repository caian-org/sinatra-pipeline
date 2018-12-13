.PHONY: test

install:
	gem install bundler && \
		bundle install

test:
	ruby ./test/app_test.rb

run:
	bundle exec rackup
