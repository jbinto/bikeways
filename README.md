# Bikeways

## Overview

This is the source code for the Toronto Bikeways Guide located at http://416.bike/

This is a web application which provides user-contributed information about Toronto's bikeway  system. It is created in response to a complete lack of information about Toronto's numbered bike system.

It will be seeded with a significant amount of original content (both route research & photography). All information will be licensed under a Creative Commons style license (specifics to be determined).

This is a work in progress. Contributions are welcome. 

* Trello: https://trello.com/b/ECtnzN5B/bikeways
* Contact: hello@jessebuchanan.ca

## Original research

See the [doc](https://github.com/jbinto/bikeways/tree/master/doc) directory for original research (e.g. route information.)

## Additional resources

* [City of Toronto - Cycling Map](http://www1.toronto.ca/wps/portal/contentonly?vgnextoid=42b3970aa08c1410VgnVCM10000071d60f89RCRD)
* [Open Data - Bikeways](http://www1.toronto.ca/wps/portal/contentonly?vgnextoid=9ecd5f9cd70bb210VgnVCM1000003dd60f89RCRD&vgnextchannel=1a66e03bb8d1e310VgnVCM10000071d60f89RCRD) (last updated ~~March~~ September 2014)


## Usage (development on OS X)

*Note: It is also possible to use Vagrant, see instructions for staging/production below.*

Prerequisites:

* Ruby 2.1.5
* Rails 4.1.8
* Postgresql 9.3.5
* PostGIS 2.1.4

I've installed these on my Mac manually. 

For ruby, I use `ruby-install` and `chruby` from Homebrew.
For [Pow](http://pow.cx/), get it from the site, and use [my .powconfig](https://raw.githubusercontent.com/jbinto/dotfiles/a1a16b3a1bd9d4611aa5a360666293bbdf9fdd56/.powconfig).
For [Powder](https://github.com/rodreegez/powder), get it from from rubygems.

For postgresql:

```
brew install postgresql postgis

# start PG on launch - from `brew info postgresql` (note: won't work in tmux!):
ln -sfv /usr/local/opt/postgresql/*.plist ~/Library/LaunchAgents
launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist

createuser --superuser bikeways
```

Now for bikeways:

```
git clone https://github.com/jbinto/bikeways.git
cd bikeways
rake db:create

# create tables
rake db:migrate

# downloads the opendata files to vendor/opendata, and imports it into postgis
rake opendata:init

# (OS X only) make app available at http://bikeways.dev/
powder link
```

Note that some Google Maps API require a callback URL to provide KML data. This means that maps may not work in development, since Google is trying to reach an internal address. However, this can be mitigated using https://localtunnel.me/ which is really cool.

## Usage (staging/production):

Use [jbinto/bikeways-ansible-playbook](https://github.com/jbinto/bikeways-ansible-playbook) to provision a server. Re-execute that playbook regularly to keep the server patched and up to date.

I use Capistrano 3 to deploy this Rails codebase. Edit `config/deploy/staging.rb` (where `staging` an arbitrary name). Here, you can set your `RAILS_ENV` and hostname. There can and will be multiple environments.

Deployment is launched via SSH, which must be correctly configured (keys for the current user). Capistrano actually pulls code a branch of this Github repo, so make sure you push first. Edit `config/deploy.rb` to tweak this.

To deploy, run:

```
cap staging deploy
```

Note: The specs are **run locally**, not on the remote server (seems strange, but it's also strange to have a test runner on a production server). If there are spec troubles, ensure you are in the Rails root and run `bundle exec rake test:all:db`, this should fix things.

The deploy command "should" perform all necessary work if starting from scratch.

Some useful commands just in case:

```
cap staging db:drop
cap staging db:create
cap staging deploy:migrate
cap staging opendata:reset
```

And to restart the server (which must be done for practically all Rails deployments):

```
cap staging rails:restart
```

For more info look at `config/deploy.rb`, there's quite a bit going on there that took a while to figure out. Capistrano 3 is new and quite different, and there's not much documentation.

## Usage (Heroku)

Not recommended. Heroku only offers PostGIS for production tier databases, which are pricey.
