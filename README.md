# Project to deploy Mediawiki with docker
- [Project to deploy Mediawiki with docker](#project-to-deploy-mediawiki-with-docker)
- [Introduction](#introduction)
- [Deploy with CLI](#deploy-with-cli)
  - [Deploy Mediawiki](#deploy-mediawiki)
  - [Deploy Mediawiki with existing database](#deploy-mediawiki-with-existing-database)
  - [Deploy Mediawiki with database and persistence container data](#deploy-mediawiki-with-database-and-persistence-container-data)
- [Deploy with docker-compose](#deploy-with-docker-compose)
  - [Deploy without persistence data ( for quickly test )](#deploy-without-persistence-data--for-quickly-test)
  - [Deploy with persistence data](#deploy-with-persistence-data)
    - [mysql.env](#mysqlenv)
    - [docker-compose .yml](#docker-compose-yml)

# Introduction

Install and run an Mediawiki instance with docker.

# Deploy with CLI

## Deploy Mediawiki 
```sh
docker run --name mysql -e MYSQL_ROOT_PASSWORD=diouxx -e MYSQL_DATABASE=wikidb -e MYSQL_USER=wiki_user -e MYSQL_PASSWORD=wiki -d mysql:5.7.25
docker run --name mediawiki --link mysql:mysql -p 80:80 -d diouxx/mediawiki
```

## Deploy Mediawiki with existing database
```sh
docker run --name wiki --link yourdatabase:mysql -p 80:80 -d diouxx/mediawiki
```

## Deploy Mediawiki with database and persistence container data

For an usage on production environnement or daily usage, it's recommanded to use a data container for persistent data.

* First, create MySQL container with volume

```sh
docker run --name mysql -e MYSQL_ROOT_PASSWORD=diouxx -e MYSQL_DATABASE=wikidb -e MYSQL_USER=wiki_user -e MYSQL_PASSWORD=wiki --volume /var/lib/mysql:/var/lib/mysql -d mysql:5.7.25
```

* Then, create Mediawiki container with volume and link MySQL container

```sh
docker run --name wiki --link mysql:mysql --volume /var/www/html/wiki:/var/www/html/wiki -p 80:80 -d diouxx/mediawiki
```

Enjoy :)

# Deploy with docker-compose

## Deploy without persistence data ( for quickly test )
```yaml
version: "3.2"

services:
#Mysql Container
  mysql:
    image: mysql:5.7.23
    container_name: mysql
    hostname: mysql
    environment:
      - MYSQL_ROOT_PASSWORD=password
      - MYSQL_DATABASE=wikidb
      - MYSQL_USER=wiki_user
      - MYSQL_PASSWORD=wiki

#Mediawiki Container
  mediawiki:
    image: diouxx/mediawiki
    container_name : wiki
    hostname: wiki
    ports:
      - "80:80"
```

## Deploy with persistence data

To deploy with docker compose, you use *docker-compose.yml* and *mysql.env* file.
You can modify **_mysql.env_** to personalize settings like :

* MySQL root password
* Mediawiki database
* Mediawiki user database
* Mediawiki user password


### mysql.env
```
MYSQL_ROOT_PASSWORD=diouxx
MYSQL_DATABASE=wikidb
MYSQL_USER=wiki_user
MYSQL_PASSWORD=wiki
```

### docker-compose .yml
```yaml
version: "3.2"

services:
#Mysql Container
  mysql:
    image: mysql:5.7.23
    container_name: mysql
    hostname: mysql
    volumes:
      - /var/lib/mysql:/var/lib/mysql
    env_file:
      - ./mysql.env
    restart: always

#Mediawiki Container
  mediawiki:
    image: diouxx/mediawiki
    container_name : wiki
    hostname: wiki
    ports:
      - "80:80"
    volumes:
      - /etc/timezone:/etc/timezone:ro
      - /etc/localtime:/etc/localtime:ro
      - /var/www/html/wiki/:/var/www/html/wiki
    restart: always
```

To deploy, just run the following command on the same directory as files

```sh
docker-compose up -d
```
