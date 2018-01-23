#!/bin/sh
set -e

if [ "${CRON}" ]; then
    exec /command.sh go-cron -s "${CRON}" -- "$@"
else
    exec /command.sh "$@"
fi
