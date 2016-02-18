# Panubo CouchDB

FROM fedora:23
MAINTAINER Andrew Cutler <andrew@panubo.com>

# Update & Install
RUN \
    echo "deltarpm=0" >> /etc/dnf/dnf.conf && \
    dnf -q -y update && \
    dnf -y install couchdb python && \
    dnf clean all && rm -rf /var/cache/yum/*

# Configure CouchDB
RUN sed -e 's/^;bind_address = .*$/bind_address = 0.0.0.0/' -i /etc/couchdb/local.ini

ADD run.sh /run.sh
ADD initialise_couch.sh /initialise_couch.sh
ADD fix_perms.sh /fix_perms.sh
RUN chmod 755 /run.sh /initialise_couch.sh /fix_perms.sh

# Add Volt Grid .py / .conf
ADD voltgrid.conf /usr/local/etc/voltgrid.conf
ADD https://raw.githubusercontent.com/voltgrid/voltgrid-pie/master/voltgrid.py /usr/local/bin/voltgrid.py
RUN chmod 755 /usr/local/bin/voltgrid.py && chmod 644 /usr/local/etc/voltgrid.conf

VOLUME  ["/etc/couchdb", "/var/lib/couchdb", "/var/log/couchdb"]
EXPOSE 5984
ENTRYPOINT ["/fix_perms.sh"]
CMD ["/usr/local/bin/voltgrid.py", "/run.sh"]
