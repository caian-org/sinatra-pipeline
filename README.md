[![Build Status](https://travis-ci.org/caianrais/sinatra-pipeline.svg?branch=master)](https://travis-ci.org/caianrais/sinatra-pipeline)

# Sample: Ruby CI/CD pipeline with Travis-CI

This repository contains a simple web application created with Sinatra, the
unit tests and a CI/CD pipeline using Travis-CI.


# Table of Contents

- [The Application](#the-application)
    - [Requirements](#requirements)
        - [System](#system)
        - [Gems](#gems)
    - [Usage](#usage)
        - [Vendor](#vendor)
        - [Running](#running)
    - [Database Schema](#database-schema)
    - [API](#api)
    - [Tests](#tests)


# The Application

The web application tries to establish a RESTful API that interacts with a
PostgreSQL database. It simply create new "person" records on POST requests and
query by the id on GET requests.


## Requirements

### System

- [Ruby](https://www.ruby-lang.org) 2.2.10 (_or superior_).


### Gems

- [sinatra](http://sinatrarb.com)
- [rake](https://github.com/ruby/rake)
- [rake-test](https://github.com/rack-test/rack-test)


## Usage

### Vendor

To install the required libraries/3rd-party dependencies, use:

```sh
$ make install
```

This target will install bundler and, with bundler, install the necessary gems.
Alternatively, just use:

```sh
$ bundle install
```


### Execution

To start the service, use:

```sh
$ make run
```

This target uses `rack`, so the service port will be binded, by default, to
`9292`. Alternatively, just use:

```sh
$ ruby src/app.py
```

To do it directly. In this case, the service port will be binded to `4567`.


## Database Schema

A aplicação Ruby espera que o banco de dados Postgres possua um banco de dados
nomeado `vagas` e uma tabela `users`. A tabela deverá seguir o seguinte schema:

```sql
id        SERIAL
name      VARCHAR(255)
surname   VARCHAR(255)
age       INT
```

Após se conectar ao banco de dados:

- **Create the database**

```sql
CREATE DATABASE sinatra;
USE sinatra;
```

- **Create the table** `users`

```sql
CREATE TABLE users (id SERIAL, name VARCHAR(255), surname VARCHAR(255), age INT);
```


## API

The application exposes three routes:

- `GET /`

    Returns a "_Hello World_".


- `GET /users/:id`

    Connects to the database and query the `users` table by the `id`. The
    response should be similar to:

    ```json
    {
        "name": "John",
        "surname": "Williams",
        "age": "86"
    }
    ```


- `POST /users`

    Connects to the database and inserts a new row into the `users` table. The
    payload should contains the keys `name` (string), `surname` (string) and
    `age` (int).

    E.g. (using the [http]() tool):

    - `http POST :4567 name="John" surname="Williams" age=86`


## Tests

To execute the unit tests, use:

```sh
$ make test
```
