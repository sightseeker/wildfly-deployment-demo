#!/bin/sh

set -e

until mysqladmin ping -h mysqlserver -u demo -pdemo; do
  >&2 echo "MySql is unavailable - sleeping"
  sleep 1
done

/opt/jboss/wildfly/bin/standalone.sh -b 0.0.0.0 -bmanagement 0.0.0.0 -Djboss.messaging.cluster.password="password" -Djboss.bind.address.private=$(hostname -i) -Dee8.preview.mode=true -c standalone-full-ha.xml
