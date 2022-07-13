# README

This README would normally document whatever steps are necessary to get the
application up and running.

## Requirement
- docker
- ruby version: `>= 2.7.4`
- packages
    - bundler: `'>= 2.1.14'`
    - yarn: `'>= 1.22.17'`

## Docker Build
```sh
docker-compose build
docker-compose run web rails db:create
docker-compose up -d
```

## Start Server
```sh
docker-compose start
# and access to http://localhost:3000
```

## Stop Server
```sh
docker-compose stop
```
