#!/bin/bash

VERSION_MAJOR_WIKI=1.27
VERSION_MINOR_WIKI=1
SRC_WIKI=https://releases.wikimedia.org/mediawiki/${VERSION_MAJOR_WIKI}/mediawiki-${VERSION_MAJOR_WIKI}.${VERSION_MINOR_WIKI}.tar.gz
TAR_WIKI=mediawiki-${VERSION_MAJOR_WIKI}.${VERSION_MINOR_WIKI}.tar.gz
FOLDER_NAME_WIKI=mediawiki
FOLDER_WIKI=mediawiki/
FOLDER_WEB=/var/www/html/

#Téléchargement et extraction des sources de GLPI
if [ "$(ls ${FOLDER_WEB}${FOLDER_WIKI})" ];
then
	echo "MediaWiki is already installed"
else
	#Download Mediwiki and change owner
	wget -P ${FOLDER_WEB} ${SRC_WIKI}
	tar -xzf ${FOLDER_WEB}${TAR_WIKI} -C ${FOLDER_WEB}
	rm -Rf ${FOLDER_WEB}${TAR_WIKI}
	mv ${FOLDER_WEB}${FOLDER_NAME_WIKI}-${VERSION_MAJOR_WIKI}.${VERSION_MINOR_WIKI} ${FOLDER_WEB}${FOLDER_NAME_WIKI}
	chown -R www-data:www-data ${FOLDER_WEB}${FOLDER_NAME_WIKI}

	#Change permission on images folder
	chown -R 544 ${FOLDER_WEB}${FOLDER_WIKI}/images

	#Modify default apache virtualhost
	echo -e "<VirtualHost *:80>\n\tDocumentRoot ${FOLDER_WEB}${FOLDER_NAME_WIKI}\n\n\t<Directory ${FOLDER_WEB}${FOLDER_NAME_WIKI}>\n\t\tAllowOverride All\n\t\tOrder Allow,Deny\n\t\tAllow from all\n\t</Directory>\n\n\tErrorLog /var/log/apache2/error-${FOLDER_NAME_WIKI}.log\n\tLogLevel warn\n\tCustomLog /var/log/apache2/acces-${FOLDER_NAME_WIKI}.log combined\n</VirtualHost>" > /etc/apache2/sites-available/000-default.conf

	#Enable rewrite module
	a2enmod rewrite && service apache2 restart && service apache2 stop

fi

#Launch apache2 foreground mode
/usr/sbin/apache2ctl -D FOREGROUND
