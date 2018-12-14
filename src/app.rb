#!/usr/bin/env ruby

require 'pg'
require 'sinatra'


class MyPostgres
  def initialize(host, port, user, pass, db)
    @client = PG::Connection.new(
      :host     => host,
      :port     => port,
      :user     => user,
      :password => pass,
      :dbname   => db
    )
  end

  def insert_user(name, surname, age)
    @client.prepare('user_insertion' ,'insert into users (name, surname, age) values ($1, $2, $3)')
    @client.exec_prepared('user_insertion', [name, surname, age])

    return 'user created', 201
  end

  def query_user(id)
    @client.prepare('user_query', 'select * from users where id = $1')
    res = @client.exec_prepared('user_query', [id])
    res.getvalue(0, 0)
    res = res[0]

    data = {
      :name    => res['name'],
      :surname => res['surname'],
      :age     => res['age']
    }

    return data, 200
  end

  def close
    @client.finish
  end
end


def pgconn
  host = (ENV['PG_HOST'] or '')
  port = (ENV['PG_PORT'] or '')
  user = (ENV['PG_USER'] or '')
  pass = (ENV['PG_PASS'] or '')
  dbnm = (ENV['PG_DBNM'] or '')

  MyPostgres.new(host, port, user, pass, dbnm)
end


def make_res(result, code)
  {
    :code    => code,
    :result => result,
    :status  => code < 400 ? 'success' : 'error'
  }
end


set :bind, '0.0.0.0'

get '/' do
  status 200
  body 'Hello World!'
end

get '/users/:id' do |id|
  content_type :json

  response = nil
  begin
    pg = pgconn
    result, code = pg.query_user(id)

    response = make_res(result, code)

  rescue StandardError => e
    res = make_res("something went wrong: #{e.message}", 500)

  else
    pg.close

  end

  status code
  body response.to_json
end

post '/users' do
  content_type :json

  # fetches the POST payload content
  payload = JSON.parse(request.body.read)
  name    = payload['name']
  surname = payload['surname']
  age     = payload['age']

  res = nil
  begin
    # connects to the postgres dabatase
    pg = postgres_connection

    # tries to insert the user into the database
    result, code = pg.insert_user(name, surname, age)

    res = make_res(result, code)

  rescue StandardError => e
    res = make_res("something went wrong: #{e.message}", 500)

  else
    pg.close

  end

  # makes the response
  status code
  body res.to_json
end
