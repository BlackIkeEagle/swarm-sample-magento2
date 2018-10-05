#!/usr/bin/env bash

currentversion=$(cat /phpapp/var/.version)
updatedfile="/phpapp/var/update/updated-$currentversion"

if [[ ! -e "$updatedfile" ]] && [[ -e "/run/php/.checkfpm" ]] ; then

    set -e

    cd /phpapp
    gosu www-data php bin/magento setup:upgrade --keep-generated
    gosu www-data php bin/magento indexer:reindex
    gosu www-data php bin/magento setup:cron:run
    gosu www-data php bin/magento c:f

    gosu www-data touch "$updatedfile"
fi
