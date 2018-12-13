#!/usr/bin/env ruby

require 'sinatra'

set :bind, '0.0.0.0'

get '/' do
  status 200
  body 'Hello World!'
end
