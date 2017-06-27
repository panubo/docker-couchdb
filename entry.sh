#!/usr/bin/env bash

echo "=== Fix CouchDB Permissions ==="
chown -R couchdb:couchdb /var/lib/couchdb
exec "$@"
