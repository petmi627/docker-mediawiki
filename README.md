# Project to deploy Mediawiki with docker

Install and run an Mediawiki instance with docker

## Deploy Mediawiki without database
```sh
docker run --name wiki -p 80:80 -d diouxx/mediawiki
```

## Deploy Mediawiki with existing database
```sh
docker run --name wiki --link some-mysql:mysql -p 80:80 -d diouxx/mediawiki
```

## Deploy Mediawiki with database and persitance container data (Recommended)

For an usage on production environnement or daily usage, it's recommanded to use a data container for persistent data.

* First, create data container

```sh
docker create --name wiki-data --volume /var/www/html/wiki:/var/www/html/wiki busybox /bin/true
```

* Then, you link your data container with GLPI container

```sh
docker run --name wiki --hostname wiki --link some-mysql:mysql --volumes-from wiki-data -p 80:80 -d diouxx/mediawiki
```
