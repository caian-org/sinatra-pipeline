require_relative '../src/app'
require 'test/unit'
require 'rack/test'

set :environment, :test

class MyAppTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_hello_world
    get '/'
    assert last_response.ok?
    assert_equal 'Hello World!', last_response.body
  end

  def test_get_user
    get '/users/1'
    assert last_response.ok?
  end

  def test_post_user
    post '/users'
    assert last_response.ok?
  end
end
