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
  MyPostgres.new(
    ENV['PG_HOST'],
    ENV['PG_PORT'],
    ENV['PG_USER'],
    ENV['PG_PASS'],
    ENV['PG_DBNM']
  )
end



set :bind, '0.0.0.0'

get '/' do
  status 200
  body 'Hello World!'
end

get '/users/:id' do |id|
  content_type :json
  status 200
  body '{}'
end

post '/users' do
  content_type :json
  status 200
  body '{}'
end
