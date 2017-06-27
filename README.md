# CouchDB Docker Container

CouchDB Dockerfile based on Fedora 22.

## Use

If `COUCHDB_DATABASE` is specified then an empty database will be created when the volume is initialised.
If `COUCHDB_USER` and `COUCHDB_PASS` is specified then an admin user will be created when the volume is initialised
and when the container is started (if no admins are present).

    docker run --publish=5984:5984 -e COUCHDB_DATABASE=baz -i -t panubo/couchdb

## Status

Production stable. However for new deployments we recommend using the official container.
