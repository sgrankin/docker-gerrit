#!/bin/sh
set -euo pipefail

: ${UID:=$(id -u nobody)}
: ${GID:=$(id -g nobody)}

chmod go+r /gerrit.war
chown -R $UID:$GID /data
/sbin/chpst -u :$UID:$GID /usr/bin/java -jar /gerrit.war init --batch --install-all-plugins --site-path /data
exec /sbin/chpst -u :$UID:$GID data/bin/gerrit.sh run
