.PHONY: test

test:
	ruby ./test/app_test.rb

run:
	bundle exec rackup
