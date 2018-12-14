require 'json'
require 'test/unit'
require 'rack/test'
require_relative '../src/app'

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

  def test_post_user
    payload = {
      :name => 'John',
      :surname => 'Williams',
      :age => 86
    }
    post '/users', payload.to_json

    resp = JSON.parse(last_response.body)
    code = resp[:code]

    assert last_response.ok?
    assert_equal 201, code
  end

  def test_get_user
    get '/users/1'

    resp = JSON.parse(last_response.body)
    code = resp[:code]

    assert last_response.ok?
    assert_equal 200, code
  end
end
