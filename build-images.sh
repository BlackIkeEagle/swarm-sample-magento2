#!/usr/bin/env sh

set -ex

if [[ -z $1 ]]; then
    echo "give the version to build"; exit 1;
fi
version=$1

rm -rf pub/static/* generated/* var/*
composer install --no-dev
php bin/magento setup:static-content:deploy -f en_US
php bin/magento setup:static-content:deploy -f nl_BE
php bin/magento setup:di:compile
composer dump-autoload -o

echo "$version" > var/.version

docker build --squash=true -f Dockerfile-nginx -t blackikeeagle/swarm-magento2-demo-nginx:$version .
docker build --squash=true -f Dockerfile-php -t blackikeeagle/swarm-magento2-demo-php:$version .

docker push blackikeeagle/swarm-magento2-demo-nginx:$version
docker push blackikeeagle/swarm-magento2-demo-php:$version
