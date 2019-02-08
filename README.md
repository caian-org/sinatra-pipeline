[![Build Status](https://travis-ci.org/caiertl/travis-pipeline-sample.svg?branch=master)](https://travis-ci.org/caiertl/travis-pipeline-sample)

# Sample: Ruby CI/CD pipeline with Travis-CI

This repository contains a simple Sinatra web application, the unit tests and a
CI/CD pipeline using Travis-CI.


# Table of Contents

- [The Application](#the-application)
    - [Requirements](#requirements)
        - [System](#system)
        - [Gems](#gems)
    - [Usage](#usage)
        - [Vendor](#vendor)
        - [Running](#running)
    - [Environment](#environment)
    - [Database Schema](#database-schema)
    - [API](#api)
    - [Tests](#tests)
- [The Pipeline](#the-pipeline)
    - [Steps](#steps)
        - [Test](#test)
        - [Build](#build)
        - [Publish](#publish)


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


## Environment

The following environment variables are used by the service:

| Variable  | Description           |
|-----------|-----------------------|
| `PG_HOST` | The database hostname |
| `PG_PORT` | The port number       |
| `PG_USER` | The database username |
| `PG_DBNM` | The username password |


## Database Schema

The service expects an already created database with a table called `users`.
The table should have the following schema:

```sql
id        SERIAL
name      VARCHAR(255)
surname   VARCHAR(255)
age       INT
```

After connecting to the database:

- __Create the database__

```sql
CREATE DATABASE sinatra;
USE sinatra;
```

- __Create the table__ `users`

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

    E.g. (using the [http](https://httpie.org) tool):

    - `http POST :4567 name="John" surname="Williams" age=86`


## Tests

To execute the unit tests, use:

```sh
$ make test
```


# The Pipeline

The pipeline tries to accomplish a flow where, given a new release (a tag), a
new Docker image is generated and pushed to a private Docker registry (in AWS,
with [ECR][ecr]. It's the "[CD][cd]" (continuous delivery) aspect of it. The
"[CI][ci]" (continuous integration) is achieved by the unit tests.

[ci]:  https://en.wikipedia.org/wiki/Continuous_integration
[cd]:  https://en.wikipedia.org/wiki/Continuous_delivery
[ecr]: https://aws.amazon.com/ecr


## Steps

### Test

- __Dependency__  : N/A.
- __Condition__   : `push`, `pull request` and `tag`
- __Description__ : Installs the dependencies and execute the unit tests.


### Build

- __Dependency__  : [`test`](#test)
- __Condition__   : `push` on `master` or `tag`
- __Description__ : Builds the Docker image.


### Publish

- __Dependency__  : [`build`](#build)
- __Condition__   : `tag`
- __Description__ : Tags the builded image and pushes to the registry.
