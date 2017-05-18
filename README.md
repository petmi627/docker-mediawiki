# Project to deploy Mediawiki with docker

[![](https://images.microbadger.com/badges/version/diouxx/mediawiki.svg)](http://microbadger.com/images/diouxx/mediawiki "Get your own version badge on microbadger.com")
[![](https://images.microbadger.com/badges/image/diouxx/mediawiki.svg)](http://microbadger.com/images/diouxx/mediawiki "Get your own image badge on microbadger.com")

Install and run an Mediawiki instance with docker

## Deploy Mediawiki without database
```sh
docker run --name wiki -p 80:80 -d diouxx/mediawiki
```

## Deploy Mediawiki with existing database
```sh
docker run --name wiki --link some-mysql:mysql -p 80:80 -d diouxx/mediawiki
```

## Deploy Mediawiki with database and persistance container data (Recommended)

For an usage on production environnement or daily usage, it's recommanded to use a data container for persistent data.

* First, create data container

```sh
docker create --name wiki-data --volume /var/www/html/wiki:/var/www/html/wiki busybox /bin/true
```

* Then, you link your data container with GLPI container

```sh
docker run --name wiki --hostname wiki --link some-mysql:mysql --volumes-from wiki-data -p 80:80 -d diouxx/mediawiki
```

## Deploy with docker-compose

To deploy with docker compose, you use *docker-compose.yml* and *mysql.env* file.
You can modify **_mysql.env_** to personalize settings like :

* MySQL root password
* GLPI database
* GLPI user database
* GLPI user password

To deploy, just run the following command on the same directory as files

```sh
docker-compose up -d
```

Enjoy :)
