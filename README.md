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


## Usage (development)

Prerequisites:

* Ruby 2.1.1
* Rails 4.1
* Postgresql 9.3
* PostGIS 2.1.1

For development, I've installed all of these on my Mac manually. It is also possible to use Vagrant, see instructions for staging/production below.

For OS X, install [pow](http://pow.cx/) and [powder](https://github.com/rodreegez/powder).

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

## Usage (staging/production):

Use [jbinto/bikeways-ansible-playbook](https://github.com/jbinto/bikeways-ansible-playbook) to provision a server.

Use Capistrano 3 to deploy. Edit `config/deploy/staging.rb` (where `staging` an arbitrary name for my target, that happens to match my RAILS_ENV).

To deploy, run

```
cap staging deploy
```

Other useful `cap` commands, scrounged from my `history`:

```
cap staging db:drop
cap staging opendata:reset
cap staging rails:restart
```