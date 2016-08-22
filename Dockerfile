
#On choisit Debian
FROM debian:latest

MAINTAINER DiouxX "github@diouxx.be"

#Ne pas poser de question à l'installation
ENV DEBIAN_FRONTEND noninteractive

RUN apt update \
&& apt -y install \
apache2 \
php5 \
php5-mysql \
php5-ldap \
php5-xcache \
imagemagick \
php5-imagick \
git \

#Changer les droits en 544 du dossier /var/www/html/mediawiki/images/
