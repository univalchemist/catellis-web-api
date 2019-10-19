# Catelli's API

A Rails/Postgres/GraphQL API for the Catelli's Restaurant App.

## Docker Install

You'll need to install Docker using one of the following:

#### Mac
https://docs.docker.com/docker-for-mac/install/

#### Windows
https://docs.docker.com/docker-for-windows/install/

#### Linux
https://www.linux.com/tutorials/how-install-docker-ce-your-desktop/

Once Docker is installed you'll need to run:
`docker-compose build`

## Start Docker
Note: To run this application you'll need multiple tabs open in a terminal

`docker-compose up`

## Installation/setup:

Note: these instructions assume you're already in an environment with a configured rbenv, ruby, and postgres installation. Is that not the case for you? Then check out the Environment section below in order to set your system up.

1. Install the required gem dependencies: `bundle install`
2. Reset and repopulate the database: `rake db:prepare`
3. Run the rails server: `rails s`

## Environment

### Ruby and rbenv

The API is currently configured to run on the latest Ruby version, 2.4.3. Ruby can be installed directly, but a more robust option is to defer to rbenv, which can manage multiple Ruby versions.

You can find instructions on installing rbenv with Homebrew [here](https://github.com/rbenv/rbenv). If you don't already have Homebrew installed, you can follow the installation instructions at the top of [this page](https://brew.sh/).

Once rbenv is installed, you should be able to install the appropriate version of ruby with `rbenv install 2.4.3`.

### Bundler

Bundler is easy enough to install with `gem install bundler`. If you want more details, you can find them at the [project's home](http://bundler.io/).

### Postgres

Any Postgres 9.x version will work (as should 10.x, but that hasn't been tested). There are a couple options, with [Postgres.app](https://postgresapp.com/) offering a click-to-install solution. Alternatively, [here is a script](https://solidfoundationwebdev.com/blog/posts/how-to-install-postgresql-using-brew-on-osx) to install via Homebrew.
