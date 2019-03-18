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

  def test_1_hello_world
    get '/'
    assert_equal 'Hello World!', last_response.body
  end

  def test_2_post_user
    payload = {
      'name'    => 'John',
      'surname' => 'Williams',
      'age'     => 86
    }

    post '/users', payload.to_json, 'CONTENT_TYPE' => 'application/json'

    response = JSON.parse(last_response.body)
    assert_equal 201, response['code']
  end

  def test_3_get_user
    get '/users/1'

    response = JSON.parse(last_response.body)
    assert_equal 200, response['code']
  end
end
