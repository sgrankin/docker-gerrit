#!/bin/sh
set -euo pipefail

: ${UID:=$(id -u nobody)}
: ${GID:=$(id -g nobody)}

cp -r /app/* /data/
chmod -R go+r /data
chown -R $UID:$GID /data
exec /sbin/chpst -u :$UID:$GID /usr/bin/java -jar /data/gerrit.war daemon --console-log --init --site-path /data
