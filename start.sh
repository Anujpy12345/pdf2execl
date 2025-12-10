#!/bin/bash

apt-get update
apt-get install -y poppler-utils

composer install --no-interaction --prefer-dist

php -S 0.0.0.0:${PORT} index.php