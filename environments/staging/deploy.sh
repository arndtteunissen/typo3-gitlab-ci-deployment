#!/usr/bin/env bash
# Blue/Green deployment script for staging
set -e

# Sync the whole content into a cache directory to speed up the transfer for future releases.
rsync -az --delete --delete-excluded --exclude-from=.rsyncignore ./ ${STAGING_SSH_USER}@${STAGING_SSH_HOST}:${STAGING_BASE_DIR}/cache/

ssh -T ${STAGING_SSH_USER}@${STAGING_SSH_HOST} <<_EOF_
    # pre-prepare
    set -xe
    cd ${STAGING_BASE_DIR}

    # prepare
    rm -rf releases/next
    mkdir -p releases/current
    mkdir -p releases/next
    mkdir -p shared/logs
    rsync -a cache/ releases/next/

    # post-prepare
    ln -s ../../../shared/Data/fileadmin/ releases/next/http/fileadmin
    ln -s ../../../../../shared/logs/ releases/next/http/typo3temp/var/logs

    # run
    # Just move the folders - This can be done better with symlinks - we know
    rm -rf releases/previous
    mv releases/current releases/previous
    mv releases/next releases/current

    # migrate
    # Update the database schema and add new tables/columns - does not delete columns or tables.
    php releases/current/vendor/bin/typo3cms database:updateschema

    # post-run
    php releases/current/vendor/bin/typo3cms cache:flush
_EOF_