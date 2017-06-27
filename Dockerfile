# Panubo CouchDB 1.6.1

FROM fedora:23
MAINTAINER Andrew Cutler <andrew@panubo.com>

ENV VOLTGRID_PIE=1.0.6 VOLTGRID_PIE_SHA1=11572a8ea15fb31cddeaa7e1438db61420556587

# Update & Install
RUN \
    echo "deltarpm=0" >> /etc/dnf/dnf.conf && \
    dnf -q -y update && \
    dnf -y install couchdb python tar procps-ng && \
    dnf clean all && rm -rf /var/cache/yum/*

# Configure CouchDB
RUN sed -e 's/^;bind_address = .*$/bind_address = 0.0.0.0/' -i /etc/couchdb/local.ini

# Add Volt Grid .py / .conf
RUN DIR=$(mktemp -d) && cd ${DIR} && \
  curl -s -L https://github.com/voltgrid/voltgrid-pie/archive/v${VOLTGRID_PIE}.tar.gz -o voltgrid-pie.tar.gz && \
  sha1sum voltgrid-pie.tar.gz && \
  echo "${VOLTGRID_PIE_SHA1} voltgrid-pie.tar.gz" | sha1sum -c - && \
  tar -C /usr/local/bin --strip-components 1 -zxf voltgrid-pie.tar.gz voltgrid-pie-${VOLTGRID_PIE}/voltgrid.py && \
  rm -rf ${DIR}
ADD voltgrid.conf /usr/local/etc/voltgrid.conf
RUN chmod 755 /usr/local/bin/voltgrid.py && chmod 644 /usr/local/etc/voltgrid.conf

COPY *.sh /
RUN chmod 755 /*.sh

VOLUME  ["/etc/couchdb", "/var/lib/couchdb", "/var/log/couchdb"]
EXPOSE 5984
ENTRYPOINT ["/entry.sh"]
CMD ["/usr/local/bin/voltgrid.py", "/run.sh"]
